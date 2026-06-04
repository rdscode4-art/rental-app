import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';
import 'package:get/get.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  await StorageService.init();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF121212),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const RidealVendorApp());
}

class RidealVendorApp extends StatelessWidget {
  const RidealVendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RiDeal Rental Vendor',
      debugShowCheckedModeBanner: false,
      enableLog: true, // Added for debugging
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppTheme.backgroundColor,
        primaryColor: AppTheme.primaryPurple,
        textTheme: GoogleFonts.poppinsTextTheme(
         ThemeData.dark().textTheme,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
