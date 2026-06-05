// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import '../utils/app_theme.dart';
// import '../widgets/glass_card.dart';
// import '../widgets/gradient_button.dart';
// import '../widgets/custom_text_field.dart';
// import '../controllers/documents_controller.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class DocumentsScreen extends StatelessWidget {
//   const DocumentsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final DocumentsController controller = Get.put(DocumentsController());

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               AppTheme.backgroundColor,
//               AppTheme.primaryGreen.withOpacity(0.05),
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Header
//               Padding(
//                 padding: const EdgeInsets.all(AppTheme.paddingLarge),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       onPressed: () => Get.back(),
//                       icon: const Icon(
//                         Icons.arrow_back_ios,
//                         color: AppTheme.whiteText,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Text(
//                       'Upload Documents',
//                       style: GoogleFonts.poppins(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: AppTheme.whiteText,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               // Form
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: AppTheme.paddingLarge,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Aadhaar Section
//                       _buildSectionHeader('Aadhaar Card', Icons.credit_card),
//                       const SizedBox(height: 12),
//                       GlassCard(
//                         child: Column(
//                           children: [
//                             CustomTextField(
//                               controller: controller.aadhaarNumberController,
//                               label: 'Aadhaar Number',
//                               hint: 'Enter 12-digit Aadhaar number',
//                               prefixIcon: Icons.numbers,
//                               keyboardType: TextInputType.number,
//                             ),
//                             const SizedBox(height: 20),
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: _buildImageUpload(
//                                     controller,
//                                     'Aadhaar Front',
//                                     'aadhaar_front',
//                                     controller.aadhaarFrontImage,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: _buildImageUpload(
//                                     controller,
//                                     'Aadhaar Back',
//                                     'aadhaar_back',
//                                     controller.aadhaarBackImage,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
                      
//                       // Driving License Section
//                       _buildSectionHeader('Driving License', Icons.badge),
//                       const SizedBox(height: 12),
//                       GlassCard(
//                         child: Column(
//                           children: [
//                             CustomTextField(
//                               controller: controller.drivingLicenseNumberController,
//                               label: 'Driving License Number',
//                               hint: 'e.g., GA0120230001234',
//                               prefixIcon: Icons.confirmation_number,
//                             ),
//                             const SizedBox(height: 20),
//                             _buildImageUpload(
//                               controller,
//                               'Driving License',
//                               'driving_license',
//                               controller.drivingLicenseImage,
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 24),
                      
//                       // Vehicle Documents Section
//                       _buildSectionHeader('Vehicle Documents', Icons.directions_car),
//                       const SizedBox(height: 12),
//                       GlassCard(
//                         child: Column(
//                           children: [
//                             CustomTextField(
//                               controller: controller.vehicleNumberController,
//                               label: 'Vehicle Number',
//                               hint: 'e.g., GA01AB1234',
//                               prefixIcon: Icons.pin,
//                             ),
//                             const SizedBox(height: 20),
//                             CustomTextField(
//                               controller: controller.vehicleNameController,
//                               label: 'Vehicle Name',
//                               hint: 'e.g., Hyundai Creta',
//                               prefixIcon: Icons.directions_car_outlined,
//                             ),
//                             const SizedBox(height: 20),
//                             // Vehicle Type Dropdown
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Vehicle Type',
//                                   style: GoogleFonts.poppins(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500,
//                                     color: AppTheme.whiteText,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Obx(() => Container(
//                                   decoration: BoxDecoration(
//                                     color: AppTheme.surfaceColor.withOpacity(0.5),
//                                     borderRadius: AppTheme.inputRadius,
//                                     border: Border.all(
//                                       color: AppTheme.greyText.withOpacity(0.2),
//                                       width: 1,
//                                     ),
//                                   ),
//                                   child: DropdownButtonFormField<String>(
//                                     value: controller.vehicleType.value,
//                                     dropdownColor: AppTheme.cardColor,
//                                     decoration: InputDecoration(
//                                       prefixIcon: const Icon(
//                                         Icons.category_outlined,
//                                         color: AppTheme.greyText,
//                                         size: 22,
//                                       ),
//                                       border: InputBorder.none,
//                                       contentPadding: const EdgeInsets.symmetric(
//                                         horizontal: 16,
//                                         vertical: 16,
//                                       ),
//                                     ),
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 15,
//                                       color: AppTheme.whiteText,
//                                     ),
//                                     items: controller.vehicleTypes.map((type) {
//                                       return DropdownMenuItem(
//                                         value: type,
//                                         child: Text(type),
//                                       );
//                                     }).toList(),
//                                     onChanged: (value) {
//                                       if (value != null) {
//                                         controller.vehicleType.value = value;
//                                       }
//                                     },
//                                   ),
//                                 )),
//                               ],
//                             ),
//                             const SizedBox(height: 20),
//                             _buildImageUpload(
//                               controller,
//                               'Vehicle Image',
//                               'vehicle',
//                               controller.vehicleImage,
//                             ),
//                             const SizedBox(height: 16),
//                             _buildImageUpload(
//                               controller,
//                               'RC (Registration Certificate)',
//                               'rc',
//                               controller.rcImage,
//                             ),
//                             const SizedBox(height: 16),
//                             _buildImageUpload(
//                               controller,
//                               'Insurance Certificate',
//                               'insurance',
//                               controller.insuranceImage,
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 30),
                      
//                       // Submit Button
//                       Obx(() => GradientButton(
//                         text: controller.isLoading.value ? 'Uploading...' : 'Submit Documents',
//                         onPressed: controller.isLoading.value ? () {} : controller.submitDocuments,
//                         icon: Icons.cloud_upload_rounded,
//                       )),
//                       const SizedBox(height: 100),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title, IconData icon) {
//     return Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: AppTheme.primaryGreen,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(icon, color: Colors.white, size: 20),
//         ),
//         const SizedBox(width: 12),
//         Text(
//           title,
//           style: GoogleFonts.poppins(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: AppTheme.whiteText,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildImageUpload(
//     DocumentsController controller,
//     String label,
//     String documentType,
//     Rx<File?> imageValue,
//   ) {
//     return Obx(() {
//       final file = imageValue.value;
      
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: GoogleFonts.poppins(
//               fontSize: 13,
//               fontWeight: FontWeight.w500,
//               color: AppTheme.greyText,
//             ),
//           ),
//           const SizedBox(height: 8),
//           GestureDetector(
//             onTap: () => controller.pickImage(documentType),
//             child: Container(
//               height: 120,
//               decoration: BoxDecoration(
//                 color: file != null
//                     ? AppTheme.primaryGreen.withOpacity(0.1)
//                     : AppTheme.surfaceColor.withOpacity(0.5),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: file != null
//                       ? AppTheme.primaryGreen
//                       : AppTheme.greyText.withOpacity(0.3),
//                   width: 2,
//                   style: BorderStyle.solid,
//                 ),
//               ),
//               child: file != null
//                   ? Stack(
//                       children: [
//                         Center(
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: Image.file(
//                               file,
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 8,
//                           right: 8,
//                           child: GestureDetector(
//                             onTap: () => controller.removeImage(documentType),
//                             child: Container(
//                               padding: const EdgeInsets.all(4),
//                               decoration: const BoxDecoration(
//                                 color: AppTheme.errorRed,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.close,
//                                 size: 16,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   : Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.add_photo_alternate_rounded,
//                             size: 32,
//                             color: AppTheme.primaryGreen,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             "Upload Image",
//                             style: GoogleFonts.poppins(
//                               fontSize: 12,
//                               color: AppTheme.greyText,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
