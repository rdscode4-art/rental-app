// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../utils/app_theme.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';


// class DocumentsController extends GetxController {
//     final ImagePicker _picker = ImagePicker();
//   // Aadhaar
//   final aadhaarNumberController = TextEditingController();
//   Rx<File?> aadhaarFrontImage = Rx<File?>(null);
//   Rx<File?> aadhaarBackImage =  Rx<File?>(null);
  
//   // Driving License
//   final drivingLicenseNumberController = TextEditingController();
//   Rx<File?> drivingLicenseImage =  Rx<File?>(null);
  
//   // Vehicle Documents
//   final vehicleNumberController = TextEditingController();
//   final vehicleNameController = TextEditingController();
//   RxString vehicleType = 'Car'.obs;
//   Rx<File?> vehicleImage = Rx<File?>(null);
//   Rx<File?> rcImage = Rx<File?>(null);
//   Rx<File?> insuranceImage = Rx<File?>(null);
  
//   RxBool isLoading = false.obs;
  
//   final List<String> vehicleTypes = ['Car', 'Bike', 'Scooty'];

//   // Simulate image picker (will work without actual image_picker package)
//   Future<void> pickImage(String documentType) async {
//     // Show dialog to choose camera or gallery
//     final source = await Get.dialog<ImageSource>(
//       AlertDialog(
//         backgroundColor: AppTheme.cardColor,
//         title: Text('Select Image Source', style: TextStyle(color: AppTheme.whiteText)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.camera_alt, color: AppTheme.primaryGreen),
//               title: Text('Camera', style: TextStyle(color: AppTheme.whiteText)),
//               onTap: () => Get.back(result: ImageSource.camera),
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library, color: AppTheme.primaryGreen),
//               title: Text('Gallery', style: TextStyle(color: AppTheme.whiteText)),
//               onTap: () => Get.back(result:ImageSource.gallery),
//             ),
//           ],
//         ),
//       ),
//     );

//     if (source == null) return;
//     final pickedFile=await _picker.pickImage(source:source);
//     if(pickedFile==null)return;

//     // Simulate image selection
//    // await Future.delayed(const Duration(milliseconds: 500));
//    final file =File(pickedFile.path);
    
//     switch (documentType) {
//       case 'aadhaar_front':
//         aadhaarFrontImage.value = file;
//         break;
//       case 'aadhaar_back':
//         aadhaarBackImage.value = file;
//         break;
//       case 'driving_license':
//         drivingLicenseImage.value = file;
//         break;
//       case 'vehicle':
//         vehicleImage.value =file;
//         break;
//       case 'rc':
//         rcImage.value = file;
//         break;
//       case 'insurance':
//         insuranceImage.value = file;
//         break;
//     }

//     Get.snackbar("Success", "Image uploaded from $source",
//         snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.successGreen, colorText: Colors.white, duration: const Duration(seconds: 1));
//   }

//   void removeImage(String documentType) {
//     switch (documentType) {
//       case 'aadhaar_front':
//         aadhaarFrontImage.value = null;
//         break;
//       case 'aadhaar_back':
//         aadhaarBackImage.value = null;
//         break;
//       case 'driving_license':
//         drivingLicenseImage.value = null;
//         break;
//       case 'vehicle':
//         vehicleImage.value = null;
//         break;
//       case 'rc':
//         rcImage.value = null;
//         break;
//       case 'insurance':
//         insuranceImage.value = null;
//         break;
//     }
//   }

//   bool validateAadhaar(String aadhaar) {
//     return aadhaar.length == 12 && RegExp(r'^[0-9]+$').hasMatch(aadhaar);
//   }

//   bool validateDrivingLicense(String dl) {
//     return dl.length >= 10 && RegExp(r'^[A-Z]{2}[0-9]{2}').hasMatch(dl);
//   }

//   bool validateVehicleNumber(String number) {
//     return number.length >= 8 && RegExp(r'^[A-Z]{2}[0-9]{2}').hasMatch(number);
//   }

//   void submitDocuments() {
//     // Validate Aadhaar
//     if (aadhaarNumberController.text.isEmpty) {
//       Get.snackbar("Error", "Please enter Aadhaar number",
//           snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
//       return;
//     }

//     if (!validateAadhaar(aadhaarNumberController.text)) {
//       Get.snackbar("Error", "Please enter valid 12-digit Aadhaar number",
//           snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
//       return;
//     }

//     if (aadhaarFrontImage.value == null || aadhaarBackImage.value == null) { 
//       Get.snackbar("Error", "Please upload both sides of Aadhaar card",
//           snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
//       return;
//     }

//     // Validate Driving License
//     if (drivingLicenseNumberController.text.isEmpty) {
//       Get.snackbar("Error", "Please enter Driving License number",
//           snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
//       return;
//     }

//     if (!validateDrivingLicense(drivingLicenseNumberController.text)) {
//       Get.snackbar("Error", "Please enter valid Driving License number",
//           snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
//       return;
//     }

//     if (drivingLicenseImage.value ==null) {
//       Get.snackbar("Error", "Please upload Driving License image",
//           snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
//       return;
//     }

//     // Validate Vehicle Documents
//     if (vehicleNumberController.text.isEmpty) {
//       Get.snackbar("Error", "Please enter Vehicle number",
//           snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
//       return;
//     }

//     if (!validateVehicleNumber(vehicleNumberController.text)) {
//       Get.snackbar("Error", "Please enter valid Vehicle number (e.g., GA01AB1234)",
//           snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
//       return;
//     }

//     if (vehicleNameController.text.isEmpty) {
//       Get.snackbar("Error", "Please enter Vehicle name",
//           snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
//       return;
//     }

//     if (vehicleImage.value ==null || rcImage.value ==null || insuranceImage.value==null) {
//       Get.snackbar("Error", "Please upload all vehicle documents (Vehicle, RC, Insurance)",
//           snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.errorRed, colorText: Colors.white);
//       return;
//     }

//     // All validations pa
//     isLoading.value = true;

//     Future.delayed(const Duration(seconds: 2), () {
//       isLoading.value = false;
//       Get.snackbar("Success", "Documents uploaded successfully!",
//           snackPosition: SnackPosition.BOTTOM, backgroundColor: AppTheme.successGreen, colorText: Colors.white, duration: const Duration(seconds: 3));
      
//       Future.delayed(const Duration(seconds: 1), () {
//         Get.back();
//       });
//     });
//   }

//   @override
//   void onClose() {
//     aadhaarNumberController.dispose();
//     drivingLicenseNumberController.dispose();
//     vehicleNumberController.dispose();
//     vehicleNameController.dispose();
//     super.onClose();
//   }
// }
