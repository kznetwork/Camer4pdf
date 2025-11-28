import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import '../utils/app_state.dart';
import '../utils/permissions.dart';
import 'preview_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isBackCamera = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    // 카메라 권한 확인
    final hasPermission = await PermissionsHelper.requestCameraPermission();
    
    if (!hasPermission) {
      if (mounted) {
        _showPermissionDeniedDialog();
      }
      return;
    }

    try {
      _cameras = await availableCameras();
      
      if (_cameras == null || _cameras!.isEmpty) {
        return;
      }

      final camera = _isBackCamera ? _cameras!.first : _cameras!.last;
      
      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      print('카메라 초기화 실패: $e');
    }
  }

  Future<void> _switchCamera() async {
    setState(() {
      _isBackCamera = !_isBackCamera;
      _isInitialized = false;
    });
    
    await _controller?.dispose();
    await _initializeCamera();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final image = await _controller!.takePicture();
      final imageFile = File(image.path);
      
      if (mounted) {
        context.read<AppState>().setCapturedImage(imageFile);
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PreviewScreen(imageFile: imageFile),
          ),
        );
      }
    } catch (e) {
      print('사진 촬영 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사진 촬영에 실패했습니다')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('카메라 권한 필요'),
        content: const Text('사진을 촬영하기 위해 카메라 접근 권한이 필요합니다.\n설정에서 권한을 허용해주세요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isInitialized && _controller != null
          ? _buildCameraPreview()
          : _buildLoadingScreen(),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 20),
          Text(
            '카메라를 준비하는 중...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 카메라 프리뷰
        CameraPreview(_controller!),
        
        // 상단 닫기 버튼
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          right: 20,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () {
              // 앱 종료 또는 다른 동작
            },
          ),
        ),
        
        // 하단 컨트롤
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 20,
              top: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 카메라 전환 버튼
                _buildControlButton(
                  icon: Icons.flip_camera_ios,
                  onPressed: _switchCamera,
                ),
                
                // 촬영 버튼
                GestureDetector(
                  onTap: _isLoading ? null : _takePicture,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isLoading ? Colors.grey : Colors.white,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(15),
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                        : null,
                  ),
                ),
                
                // 갤러리 버튼 (임시)
                _buildControlButton(
                  icon: Icons.photo_library,
                  onPressed: () {
                    // 갤러리 기능 구현 가능
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black.withOpacity(0.5),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 30),
        onPressed: onPressed,
      ),
    );
  }
}

