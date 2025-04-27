import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints/core/constants.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:complaints/models/user_model.dart';
import 'package:complaints/providers/current_user_provider.dart';
import 'package:complaints/providers/firestore_service_provider.dart';
import 'package:complaints/services/ai_implementation/spam_checker.dart';
import 'package:complaints/services/db_services/cloudinary_services.dart';
import 'package:complaints/services/db_services/firestore_services.dart';
import 'package:complaints/services/media_services/image_labeling_service.dart';
import 'package:complaints/widgets/custom_alert_dialog.dart';
import 'package:complaints/widgets/custom_button.dart';
import 'package:complaints/widgets/custom_snackbar.dart';
import 'package:complaints/providers/image_provider.dart';
import 'package:complaints/widgets/custom_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ComplaintFormScreen extends ConsumerStatefulWidget {
  const ComplaintFormScreen({super.key});

  @override
  ConsumerState<ComplaintFormScreen> createState() =>
      _ComplaintFormScreenState();
}

class _ComplaintFormScreenState extends ConsumerState<ComplaintFormScreen>
    with TickerProviderStateMixin {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final otherCategoryController = TextEditingController();
  final FocusNode titleFocus = FocusNode();
  final FocusNode otherFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  final formKey = GlobalKey<FormState>();
  String? selectedCategory;
  final picker = ImagePicker();
  bool containsImages = false;
  bool isScanning = false;
  bool hasScannedImages = false;
  List<String> scannedLabels = [];

  final List<String> categories = [
    'Billing',
    'Service',
    'Technical',
    'Product Quality',
    'Delivery',
    'Customer Support',
    'Infrastructure',
    'Cleanliness',
    'Safety',
    'Public Transport',
    'Water Supply',
    'Electricity',
    'Internet',
    'Noise Pollution',
    'Road Conditions',
    'Traffic Management',
    'Healthcare',
    'Waste Management',
    'Education',
    'Parking',
    'Environment',
    'Other'
  ];

  bool get hasFormData {
    return titleController.text.trim().isNotEmpty ||
        descriptionController.text.trim().isNotEmpty ||
        selectedCategory != null ||
        otherCategoryController.text.trim().isNotEmpty ||
        ref.read(imageListProvider).isNotEmpty;
  }

  void _showExitConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: 'Discard Changes?',
        subtitle: 'You have unsaved changes. Are you sure you want to exit?',
        confirmText: 'Discard',
        onConfirmPressed: () {
          _clearFormData();
          context.pop();
        },
      ),
    );
  }

  void _clearFormData() {
    ref.read(imageListProvider.notifier).clearImages();
  }

  Future<void> pickImagesfromGallery() async {
    final images = await picker.pickMultiImage();
    if (images.isEmpty) return;

    final currentImages = ref.read(imageListProvider);
    final availableSlots = 10 - currentImages.length;

    if (images.length > availableSlots) {
      if (mounted) {
        customSnackbar(
            context: context,
            message: 'You can only upload upto 10 images',
            iconName: Icons.image_not_supported);
      }
    }

    final imagesToAdd = images.take(availableSlots).toList();
    ref.read(imageListProvider.notifier).addImages(imagesToAdd);

    // Reset scan status if new images are added
    if (hasScannedImages && imagesToAdd.isNotEmpty) {
      setState(() {
        hasScannedImages = false;
      });
    }
  }

  Future<void> showImageSourceSheet() async {
    showModalBottomSheet(
      backgroundColor: AppColors.darkPink,
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) => Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ListTile(
              leading:
                  const Icon(Icons.photo_camera, color: AppColors.textColor),
              title: Text('Take from Camera', style: AppTextStyles.medium(20)),
              onTap: () async {
                Navigator.pop(context);
                final picked =
                    await picker.pickImage(source: ImageSource.camera);
                if (picked != null) {
                  final currentImages = ref.read(imageListProvider);
                  if (currentImages.length >= 10) {
                    if (mounted) {
                      customSnackbar(
                          context: context,
                          message: 'You can only upload up to 10 images',
                          iconName: Icons.image_not_supported);
                    }
                    return;
                  }
                  ref.read(imageListProvider.notifier).addImages([picked]);

                  // Reset scan status if new image is added
                  if (hasScannedImages) {
                    setState(() {
                      hasScannedImages = false;
                    });
                  }
                }
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: const Divider(
                color: AppColors.lightGrey,
              ),
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: AppColors.textColor),
              title:
                  Text('Choose from Gallery', style: AppTextStyles.medium(20)),
              onTap: () async {
                Navigator.pop(context);
                await pickImagesfromGallery();
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: const Divider(
                color: AppColors.lightGrey,
              ),
            ),
            Text(
              'Upload up to 10 images regarding your complaint or issue.\n\n'
              '⚠️ Please upload only relevant images.\n'
              'Unnecessary or inappropriate uploads may lead to blocking or legal actions.',
              style: AppTextStyles.regular(16, color: AppColors.textColor),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scanImages() async {
    final selectedImages = ref.read(imageListProvider);
    if (selectedImages.isEmpty) {
      customSnackbar(
        context: context,
        message: 'No images to scan',
        iconName: Icons.image_not_supported,
      );
      return;
    }

    setState(() {
      isScanning = true;
    });

    try {
      // Convert XFiles to Files
      final imageFiles =
          selectedImages.map((xfile) => File(xfile.path)).toList();

      // Get all unique labels from images
      final labels = await labelImages(imageFiles);

      setState(() {
        scannedLabels = labels; // Now this is just List<String>
        isScanning = false;
        hasScannedImages = true;
      });

      if (mounted) {
        customSnackbar(
          context: context,
          message: 'Found ${labels.length} relevant items in images',
          iconName: Icons.check_circle,
        );
      }
    } catch (e) {
      setState(() {
        isScanning = false;
      });

      if (mounted) {
        customSnackbar(
          context: context,
          message: 'Error scanning images',
          iconName: Icons.error,
        );
      }
    }
  }

  Future<void> submitTheForm(UserModel user) async {
    if (titleController.text.trim().isEmpty) {
      customSnackbar(
        context: context,
        message: 'Please enter a title for your complaint',
        iconName: Icons.error,
      );
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      customSnackbar(
        context: context,
        message: 'Please describe your complaint',
        iconName: Icons.error,
      );
      return;
    }

    if (selectedCategory == null) {
      customSnackbar(
        context: context,
        message: 'Please select a category',
        iconName: Icons.error,
      );
      return;
    }

    if (selectedCategory == 'Other' &&
        otherCategoryController.text.trim().isEmpty) {
      customSnackbar(
        context: context,
        message: 'Please specify the category',
        iconName: Icons.error,
      );
      return;
    }

    // Check if images need scanning before submitting
    final selectedImages = ref.read(imageListProvider);
    if (selectedImages.isNotEmpty && !hasScannedImages) {
      customSnackbar(
        context: context,
        message: 'Please scan your images before submitting',
        iconName: Icons.warning,
      );
      return;
    }

    // Show loading indicator
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    try {
      // 1. Upload images only if they exist
      List<String> uploadedUrls = [];
      if (selectedImages.isNotEmpty) {
        final List<String> imagePaths =
            selectedImages.map((xfile) => xfile.path).toList();
        uploadedUrls = await CloudinaryService().uploadImages(imagePaths);
      }

      // 2. Check for spam (include empty image labels if no images)
      final isSpam = await SpamChecker().checkSpam(
        title: titleController.text.trim(),
        category: selectedCategory == 'Other'
            ? otherCategoryController.text.trim()
            : selectedCategory!,
        description: descriptionController.text.trim(),
        imageData:
            selectedImages.isNotEmpty ? scannedLabels : ["No images provided"],
      );

      // 3. Create complaint model
      final newComplaint = ComplaintModel(
        complaintId:
            FirebaseFirestore.instance.collection('complaints').doc().id,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory == 'Other'
            ? otherCategoryController.text.trim()
            : selectedCategory!,
        userId: user.id,
        userName: user.name,
        userEmail: user.email,
        userProfileUrl: user.profileUrl,
        submittedAt: DateTime.now(),
        isPosted: false,
        userNotified: false,
        adminNotified: false,
        attachments: hasScannedImages ? uploadedUrls : [],

        attachmentsResolved: [],
        // Update status based on spam check
        isSpam: isSpam,

        status: isSpam ? 'Rejected' : 'Pending',

        rejectionReason: isSpam ? 'Marked as potential spam' : null,
      );

      // 4. Submit to Firestore
      if (!mounted) return;
      await FirestoreServices().submitComplaint(newComplaint, context);

      if (mounted) {
        await ref.read(firestoreServiceProvider).updateUserData(
            userID: user.id,
            isAdmin: false,
            updates: {
              'total_complaints': user.totalComplaints + 1,
            },
            context: context);
      }

      if (mounted) {
        Navigator.of(context, rootNavigator: true)
            .pop(); // Close loading dialog

        if (isSpam) {
          // Show spam warning and navigate back after dismissal
          await showDialog(
            context: context,
            builder: (context) => CustomAlertDialog(
              title: 'Complaint Rejected',
              subtitle:
                  'Your complaint was marked as potential spam. Please ensure your complaints are constructive and relevant.',
              onConfirmPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _clearFormData();
                context.pop(); // Navigate back to previous screen
              },
            ),
          );
        } else {
          _clearFormData();
          context.pop();
          customSnackbar(
            context: context,
            message: 'Complaint submitted successfully',
            iconName: Icons.check_circle,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        customSnackbar(
          context: context,
          message: 'Error submitting complaint: ${e.toString()}',
          iconName: Icons.error,
        );
      }
    }
  }

  void showImagePreview(File imageFile) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(
              imageFile,
              fit: BoxFit.cover,
              height: 700.h,
              width: double.infinity,
            ),
            SizedBox(height: 16.h),
            TextButton(
              child: Text('Close', style: AppTextStyles.regular(24)),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    otherCategoryController.dispose();
    titleFocus.dispose();
    otherFocus.dispose();
    descFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedImages = ref.watch(imageListProvider);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (hasFormData) {
          _showExitConfirmDialog();
          return false;
        }
        _clearFormData();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                if (hasFormData) {
                  _showExitConfirmDialog();
                } else {
                  _clearFormData();
                  context.pop();
                }
              },
              icon: const Icon(Icons.arrow_back_ios)),
          title: Text('File Complaint',
              style: AppTextStyles.bold(20, color: AppColors.textColor)),
          backgroundColor: AppColors.darkBlueGrey,
          shadowColor: AppColors.darkest,
          elevation: 4,
          iconTheme: const IconThemeData(color: AppColors.textColor),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // OR Divider

                  SizedBox(height: 24.h),

                  // Form Fields
                  CustomTextFields(
                    labelText: 'Title of Complaint',
                    prefixIcon: Icons.title,
                    controller: titleController,
                    focusNode: titleFocus,
                    validator: ValidationType.required,
                  ),
                  SizedBox(height: 16.h),

                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    menuMaxHeight: 240.h,
                    borderRadius: BorderRadius.circular(16.r),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.category,
                          color: AppColors.textColor),
                      labelText: 'Category',
                      labelStyle: AppTextStyles.medium(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                    ),
                    dropdownColor: AppColors.darkPinkAccent,
                    value: selectedCategory,
                    style: AppTextStyles.medium(16),
                    icon: const Icon(Icons.arrow_drop_down,
                        color: AppColors.textColor),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => selectedCategory = value),
                    validator: (value) =>
                        value == null ? 'Select a category' : null,
                  ),
                  SizedBox(height: 16.h),

                  if (selectedCategory == 'Other') ...[
                    CustomTextFields(
                      labelText: 'Specify Other Category',
                      prefixIcon: Icons.edit,
                      controller: otherCategoryController,
                      focusNode: otherFocus,
                      validator: ValidationType.required,
                    ),
                    SizedBox(height: 16.h),
                  ],

                  // Description
                  CustomTextFields(
                      focusNode: descFocus,
                      controller: descriptionController,
                      maxLines: 5,
                      labelText: 'Description',
                      validator: ValidationType.required),
                  SizedBox(height: 24.h),

                  if (!containsImages) ...[
                    ListTile(
                      tileColor: AppColors.darkest.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r)),
                      title: Text(
                        'You have images any regarding this issue ?',
                        style: AppTextStyles.regular(16),
                      ),
                      trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.darkPinkAccent),
                          onPressed: () => setState(() {
                                containsImages = true;
                              }),
                          child: Text(
                            'Yes',
                            style: AppTextStyles.regular(16),
                          )),
                    )
                  ],
                  if (selectedImages.length < 10 && containsImages) ...[
                    GestureDetector(
                      onTap: showImageSourceSheet,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 16.h, horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: AppColors.darkest.withValues(alpha: .7),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.lightGrey.withValues(alpha: .3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              color: AppColors.textColor,
                              size: 24.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Add Images',
                              style: AppTextStyles.medium(16),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: AppColors.darkPinkAccent,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                '${10 - selectedImages.length} left',
                                style: AppTextStyles.regular(12)
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  if (selectedImages.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    Text('Selected Images (${selectedImages.length}/10)',
                        style: AppTextStyles.medium(14)),
                    SizedBox(height: 12.h),
                    SizedBox(
                      height: 100.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedImages.length,
                        itemBuilder: (context, index) {
                          final file = File(selectedImages[index].path);
                          return Padding(
                            padding: EdgeInsets.only(right: 12.w),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            FullImageView(imageFile: file),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.file(
                                      file,
                                      height: 100.h,
                                      width: 100.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      ref
                                          .read(imageListProvider.notifier)
                                          .removeImage(index);

                                      // If there are still images and we've scanned before,
                                      // we need to reset scan status
                                      if (hasScannedImages &&
                                          ref
                                              .read(imageListProvider)
                                              .isNotEmpty) {
                                        setState(() {
                                          hasScannedImages = false;
                                        });
                                      }
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.darkPinkAccent,
                                      ),
                                      padding: EdgeInsets.all(4.w),
                                      child: Icon(Icons.close,
                                          color: Colors.white, size: 16.sp),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  SizedBox(height: 32.h),
                  // Loading indicator when scanning
                  if (isScanning) ...[
                    Center(
                      child: Column(
                        children: [
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.darkPink),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Scanning images...',
                            style: AppTextStyles.medium(16),
                          ),
                        ],
                      ),
                    ),
                  ] else if (selectedImages.isNotEmpty &&
                      !hasScannedImages) ...[
                    CustomButton(
                        onTap: scanImages,
                        buttonText: 'Scan Images',
                        bgColor: AppColors.darkGreen,
                        imageUrl: 'asets/images/scan-svgrepo-com.svg')
                  ] else ...[
                    CustomButton(
                        onTap: () async {
                          final user = ref.read(currentUserProvider).value!;
                          await submitTheForm(user);
                        },
                        buttonText: 'Submit Complaint',
                        imageUrl: 'asets/images/send-alt-1-svgrepo-com.svg'),
                  ],
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FullImageView extends StatelessWidget {
  final File imageFile;

  const FullImageView({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Image.file(imageFile),
      ),
    );
  }
}
