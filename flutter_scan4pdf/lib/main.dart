import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/camera_screen.dart';
import 'utils/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Scan4PDFApp());
}

class Scan4PDFApp extends StatelessWidget {
  const Scan4PDFApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Scan4PDF',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const CameraScreen(),
      ),
    );
  }
}

