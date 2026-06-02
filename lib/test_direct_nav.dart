// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'screens/main_navigation.dart';
// import 'utils/app_theme.dart';

// void main() {
//   runApp(const TestDirectNav());
// }

// class TestDirectNav extends StatelessWidget {
//   const TestDirectNav({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Test Navigation',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: AppTheme.backgroundColor,
//         primaryColor: AppTheme.primaryPurple,
//         textTheme: GoogleFonts.poppinsTextTheme(
//           ThemeData.dark().textTheme,
//         ),
//         useMaterial3: true,
//       ),
//       home: const TestScreen(),
//     );
//   }
// }

// class TestScreen extends StatelessWidget {
//   const TestScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               AppTheme.backgroundColor,
//               AppTheme.primaryPurple.withOpacity(0.2),
//             ],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Navigation Test',
//                 style: GoogleFonts.poppins(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 40),
//               ElevatedButton(
//                 onPressed: () {
//                   print("Button 1: Get.to()");
//                   Get.to(() => const MainNavigation());
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppTheme.primaryPurple,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 40,
//                     vertical: 20,
//                   ),
//                 ),
//                 child: Text(
//                   'Test Get.to()',
//                   style: GoogleFonts.poppins(fontSize: 16),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   print("Button 2: Get.offAll()");
//                   Get.offAll(() => const MainNavigation());
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppTheme.primaryBlue,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 40,
//                     vertical: 20,
//                   ),
//                 ),
//                 child: Text(
//                   'Test Get.offAll()',
//                   style: GoogleFonts.poppins(fontSize: 16),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   print("Button 3: Navigator.push()");
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => const MainNavigation(),
//                     ),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppTheme.accentPink,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 40,
//                     vertical: 20,
//                   ),
//                 ),
//                 child: Text(
//                   'Test Navigator.push()',
//                   style: GoogleFonts.poppins(fontSize: 16),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
