import 'dart:io';
import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  File? _capturedImage;
  List<File> _capturedImages = [];

  File? get capturedImage => _capturedImage;
  List<File> get capturedImages => _capturedImages;

  void setCapturedImage(File? image) {
    _capturedImage = image;
    if (image != null) {
      _capturedImages.add(image);
    }
    notifyListeners();
  }

  void clearCapturedImage() {
    _capturedImage = null;
    notifyListeners();
  }

  void clearAllImages() {
    _capturedImages.clear();
    _capturedImage = null;
    notifyListeners();
  }
}

