import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class PDFGenerator {
  /// 단일 이미지를 PDF로 변환
  static Future<File?> createPDFFromImage(File imageFile) async {
    try {
      final pdf = pw.Document();
      
      // 이미지 로드
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);
      
      if (image == null) {
        print('이미지 디코딩 실패');
        return null;
      }

      // PDF 페이지 추가
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(imageBytes),
                fit: pw.BoxFit.contain,
              ),
            );
          },
        ),
      );

      // PDF 저장
      final output = await _getSaveDirectory();
      final fileName = 'scan_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${output.path}/$fileName');
      
      await file.writeAsBytes(await pdf.save());
      print('PDF 생성 성공: ${file.path}');
      
      return file;
    } catch (e) {
      print('PDF 생성 실패: $e');
      return null;
    }
  }

  /// 여러 이미지를 하나의 PDF로 변환
  static Future<File?> createPDFFromImages(List<File> imageFiles) async {
    try {
      final pdf = pw.Document();

      for (final imageFile in imageFiles) {
        final imageBytes = await imageFile.readAsBytes();
        
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) {
              return pw.Center(
                child: pw.Image(
                  pw.MemoryImage(imageBytes),
                  fit: pw.BoxFit.contain,
                ),
              );
            },
          ),
        );
      }

      // PDF 저장
      final output = await _getSaveDirectory();
      final fileName = 'scan_multi_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${output.path}/$fileName');
      
      await file.writeAsBytes(await pdf.save());
      print('PDF 생성 성공: ${file.path}');
      
      return file;
    } catch (e) {
      print('PDF 생성 실패: $e');
      return null;
    }
  }

  /// 저장 디렉토리 가져오기
  static Future<Directory> _getSaveDirectory() async {
    if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    } else {
      // Android
      final directory = await getExternalStorageDirectory();
      return directory ?? await getApplicationDocumentsDirectory();
    }
  }

  /// PDF 파일 경로 가져오기
  static Future<String> getPDFDirectory() async {
    final dir = await _getSaveDirectory();
    return dir.path;
  }
}

