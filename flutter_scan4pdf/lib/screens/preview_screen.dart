import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../utils/pdf_generator.dart';

class PreviewScreen extends StatefulWidget {
  final File imageFile;

  const PreviewScreen({super.key, required this.imageFile});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  bool _isSaving = false;
  bool _isGeneratingPDF = false;

  Future<void> _saveToGallery() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final bytes = await widget.imageFile.readAsBytes();
      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: 'scan_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (mounted) {
        if (result['isSuccess'] == true) {
          _showSuccessDialog('사진이 갤러리에 저장되었습니다.');
        } else {
          _showErrorDialog('사진 저장에 실패했습니다.');
        }
      }
    } catch (e) {
      print('저장 실패: $e');
      if (mounted) {
        _showErrorDialog('사진 저장 중 오류가 발생했습니다.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _exportToPDF() async {
    setState(() {
      _isGeneratingPDF = true;
    });

    try {
      final pdfFile = await PDFGenerator.createPDFFromImage(widget.imageFile);

      if (mounted) {
        if (pdfFile != null) {
          final fileName = pdfFile.path.split('/').last;
          _showSuccessDialog(
            'PDF가 저장되었습니다.\n파일명: $fileName',
          );
        } else {
          _showErrorDialog('PDF 생성에 실패했습니다.');
        }
      }
    } catch (e) {
      print('PDF 생성 실패: $e');
      if (mounted) {
        _showErrorDialog('PDF 생성 중 오류가 발생했습니다.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingPDF = false;
        });
      }
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('알림'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 이미지 표시
          Center(
            child: InteractiveViewer(
              child: Image.file(
                widget.imageFile,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 상단 닫기 버튼
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 하단 액션 버튼들
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 20,
                top: 20,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 저장 버튼
                  _buildActionButton(
                    icon: Icons.save_alt,
                    label: '저장',
                    onPressed: _isSaving ? null : _saveToGallery,
                    isLoading: _isSaving,
                  ),

                  // PDF 버튼
                  _buildActionButton(
                    icon: Icons.picture_as_pdf,
                    label: 'PDF',
                    onPressed: _isGeneratingPDF ? null : _exportToPDF,
                    isLoading: _isGeneratingPDF,
                  ),

                  // 확인 버튼
                  _buildActionButton(
                    icon: Icons.check_circle,
                    label: '확인',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: onPressed == null
                ? Colors.grey.withOpacity(0.5)
                : Colors.white.withOpacity(0.2),
          ),
          child: IconButton(
            icon: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(icon, color: Colors.white, size: 30),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

