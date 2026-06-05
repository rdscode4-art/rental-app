// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:rentalvender/controllers/edit_profile_controller.dart';
// import '../utils/app_theme.dart';
// import '../widgets/glass_card.dart';
// import '../widgets/gradient_button.dart';
// import '../widgets/custom_text_field.dart';
// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({super.key});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreen();
// }

// class _EditProfileScreen extends State<EditProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final EditProfileController controller = Get.put(EditProfileController());

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               AppTheme.backgroundColor,
//               AppTheme.primaryPurple.withOpacity(0.1),
//               AppTheme.primaryBlue.withOpacity(0.1),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(AppTheme.paddingLarge),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Back button
//                 IconButton(
//                   onPressed: () => Get.back(),
//                   icon: const Icon(
//                     Icons.arrow_back_ios,
//                     color: AppTheme.whiteText,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Header
//                 Center(
//                   child: Column(
//                     children: [
//                       ShaderMask(
//                         shaderCallback: (bounds) =>
//                             AppTheme.primaryGradient.createShader(bounds),
//                         child: Text(
//                           'Update Your Profile',
//                           style: GoogleFonts.poppins(
//                             fontSize: 32,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         'Edit your details below',
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           color: AppTheme.greyText,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 // Profile Photo
//                 Center(
//                   child: GestureDetector(
//                     onTap: controller.pickProfileImage,
//                     child: Obx(
//                       () => Stack(
//                         children: [
//                           Container(
//                             width: 100,
//                             height: 100,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: AppTheme.cardColor,
//                               border: Border.all(
//                                 color: AppTheme.primaryPurple,
//                                 width: 2,
//                               ),
//                             ),
//                             child: controller.profileImage.value != null
//                                 ? ClipOval(
//                                     child: Image.file(
//                                       controller.profileImage.value!,
//                                       fit: BoxFit.cover,
//                                       width: 100,
//                                       height: 100,
//                                     ),
//                                   )
//                                 : controller.profilePhotoUrl.value.isNotEmpty
//                                     ? ClipOval(
//                                         child: Image.network(
//                                           controller.profilePhotoUrl.value,
//                                           fit: BoxFit.cover,
//                                           width: 100,
//                                           height: 100,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return const Icon(
//                                               Icons.person,
//                                               size: 50,
//                                               color: AppTheme.greyText,
//                                             );
//                                           },
//                                           loadingBuilder: (context, child, loadingProgress) {
//                                             if (loadingProgress == null) return child;
//                                             return const Center(
//                                               child: CircularProgressIndicator(
//                                                 color: AppTheme.primaryPurple,
//                                               ),
//                                             );
//                                           },
//                                         ),
//                                       )
//                                     : const Icon(
//                                         Icons.person,
//                                         size: 50,
//                                         color: AppTheme.greyText,
//                                       ),
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             right: 0,
//                             child: Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 gradient: AppTheme.primaryGradient,
//                                 shape: BoxShape.circle,
//                                 boxShadow: AppTheme.glowShadow,
//                               ),
//                               child: const Icon(
//                                 Icons.camera_alt,
//                                 size: 18,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 // Signup Form
//                 GlassCard(
//                   child: Column(
//                     children: [
//                       CustomTextField(
//                         controller: controller.nameController,
//                         label: 'Full Name',
//                         hint: 'Enter your full name',
//                         prefixIcon: Icons.person_outline,
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextField(
//                         controller: controller.mobileController,
//                         label: 'Mobile Number',
//                         hint: 'Enter your mobile number',
//                         prefixIcon: Icons.phone_outlined,
//                         keyboardType: TextInputType.phone,
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextField(
//                         controller: controller.emailController,
//                         label: 'Email',
//                         hint: 'Enter your email',
//                         prefixIcon: Icons.email_outlined,
//                         keyboardType: TextInputType.emailAddress,
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextField(
//                         controller: controller.agencyController,
//                         label: 'Agency Name',
//                         hint: 'Enter your agency name',
//                         prefixIcon: Icons.business_outlined,
//                       ),
//                       const SizedBox(height: 20),
//                       // City Field
//                       CustomTextField(
//                         controller: controller.cityController,
//                         label: 'City',
//                         hint: 'Enter your city',
//                         prefixIcon: Icons.location_city_outlined,
//                       ),
//                       const SizedBox(height: 30),
//                       // Register Button
//                       Obx(
//                         () => GradientButton(
//                           text: controller.isLoading.value
//                               ? 'Saving...'
//                               : 'Save Changes',
//                           onPressed: controller.saveProfile,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
