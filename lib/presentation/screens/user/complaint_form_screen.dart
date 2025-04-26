import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:complaints/core/constants.dart';
import 'package:complaints/models/complaint_model.dart';
import 'package:complaints/models/user_model.dart';
import 'package:complaints/providers/current_user_provider.dart';
import 'package:complaints/services/firestore_services.dart';
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

    ref.read(imageListProvider.notifier).addImages(images);
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
                final images = await picker.pickMultiImage();
                if (images.isEmpty) return;

                final currentImages = ref.read(imageListProvider);
                final availableSlots = 10 - currentImages.length;

                if (images.length > availableSlots) {
                  if (mounted) {
                    customSnackbar(
                        context: context,
                        message: 'You can only upload up to 10 images',
                        iconName: Icons.image_not_supported);
                  }
                }

                final imagesToAdd = images.take(availableSlots).toList();
                ref.read(imageListProvider.notifier).addImages(imagesToAdd);
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
  Widget build(BuildContext context) {
    final selectedImages = ref.watch(imageListProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () => context.pop(),
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
                // Voice Input Section
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.darkest.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.lightGrey.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Use voice input to describe your issue',
                        style: AppTextStyles.medium(16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.darkPink,
                              AppColors.darkPinkAccent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkPink.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.mic,
                              size: 32.sp, color: AppColors.textColor),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // OR Divider
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.lightGrey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text('OR', style: AppTextStyles.medium(16)),
                    ),
                    const Expanded(child: Divider(color: AppColors.lightGrey)),
                  ],
                ),
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
                    prefixIcon:
                        const Icon(Icons.category, color: AppColors.textColor),
                    labelText: 'Category',
                    labelStyle: AppTextStyles.medium(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide.none,
                    ),
                    filled: false,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                                  onTap: () => ref
                                      .read(imageListProvider.notifier)
                                      .removeImage(index),
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
                CustomButton(
                    onTap: () async {
                      final user = ref.read(currentUserProvider).value!;
                      await submitTheForm(user);
                    },
                    buttonText: 'Submit Complaint',
                    imageUrl: 'asets/images/send-alt-1-svgrepo-com.svg'),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitTheForm(UserModel user) async {
    final newComplaint = ComplaintModel(
      complaintId: FirebaseFirestore.instance.collection('complaints').doc().id,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      category: selectedCategory == null ? 'other' : selectedCategory!,
      userId: user.id,
      userName: user.name,
      userEmail: user.email,
      userProfileUrl: user.profileUrl,
      attachments: [],
      attachmentsResolved: [],
      status: 'Pending',
      isSpam: false,
      submittedAt: DateTime.now(),
      userNotified: false,
      adminNotified: false,
      isPosted: false,
    );

// Call the submit function
    await FirestoreServices().submitComplaint(newComplaint, context);
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
