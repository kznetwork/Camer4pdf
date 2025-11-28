import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted || status.isLimited;
  }

  static Future<bool> requestPhotosPermission() async {
    final status = await Permission.photos.request();
    return status.isGranted || status.isLimited;
  }

  static Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  static Future<bool> checkStoragePermission() async {
    final status = await Permission.storage.status;
    return status.isGranted || status.isLimited;
  }

  static Future<Map<String, bool>> requestAllPermissions() async {
    final camera = await requestCameraPermission();
    final photos = await requestPhotosPermission();
    
    return {
      'camera': camera,
      'photos': photos,
    };
  }
}

