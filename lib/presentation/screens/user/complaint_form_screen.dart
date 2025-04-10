import 'dart:io';
import 'package:complaints/core/constants.dart';
import 'package:complaints/presentation/widgets/custom_button.dart';
import 'package:complaints/presentation/widgets/custom_snackbar.dart';
import 'package:complaints/providers/image_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final formKey = GlobalKey<FormState>();
  String? selectedCategory;
  final picker = ImagePicker();

  final List<String> categories = [
    'Billing',
    'Service',
    'Technical',
    'Product Quality',
    'Delivery',
    'Customer Support',
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('File a Complaint',
            style: AppTextStyles.bold(20, color: AppColors.textColor)),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              /// Title
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.title),
                  labelText: 'Title of Complaint',
                  labelStyle:
                      AppTextStyles.medium(16, color: AppColors.textColor),
                  filled: true,
                  fillColor: AppColors.darkBlueGrey,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                validator: (value) => value!.isEmpty ? 'Enter a title' : null,
              ),
              SizedBox(height: 16.h),

              /// Category Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.category_outlined),
                  labelText: 'Category',
                  labelStyle:
                      AppTextStyles.medium(16, color: AppColors.textColor),
                  filled: true,
                  fillColor: AppColors.darkBlueGrey,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                dropdownColor: AppColors.darkPinkAccent,
                value: selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(category, style: AppTextStyles.medium(16)),
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedCategory = value),
                validator: (value) =>
                    value == null ? 'Select a category' : null,
              ),
              if (selectedCategory == 'Other')
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: TextFormField(
                    controller: otherCategoryController,
                    decoration: InputDecoration(
                      labelText: 'Specify Other Category',
                      labelStyle:
                          AppTextStyles.medium(16, color: AppColors.textColor),
                      filled: true,
                      fillColor: AppColors.darkBlueGrey,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r)),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Enter category' : null,
                  ),
                ),
              SizedBox(height: 16.h),

              /// Description
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Description',
                  labelStyle:
                      AppTextStyles.medium(16, color: AppColors.textColor),
                  filled: true,
                  fillColor: AppColors.darkBlueGrey,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r)),
                ),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a description' : null,
              ),
              SizedBox(height: 16.h),

              /// Upload Images
              /// Upload Images UI
              Center(
                child: ElevatedButton.icon(
                  onPressed: showImageSourceSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkPink,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    elevation: 4,
                  ),
                  icon: Icon(Icons.add_a_photo,
                      color: AppColors.textColor, size: 22.sp),
                  label: Text('Upload Images',
                      style:
                          AppTextStyles.medium(16, color: AppColors.textColor)),
                ),
              ),
              if (selectedImages.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Text('${selectedImages.length} selected',
                      style:
                          AppTextStyles.medium(14, color: AppColors.lightGrey)),
                ),

              SizedBox(height: 12.h),

              /// Thumbnails Grid
              if (selectedImages.isNotEmpty)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: List.generate(selectedImages.length, (index) {
                      final file = File(selectedImages[index].path);
                      return GestureDetector(
                        onTap: () => showImagePreview(file),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Image.file(
                                file,
                                height: 80.h,
                                width: 80.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: -6,
                              right: -6,
                              child: GestureDetector(
                                onTap: () => ref
                                    .read(imageListProvider.notifier)
                                    .removeImage(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withValues(alpha: 0.6),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(Icons.close,
                                      color: Colors.white, size: 16.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

              SizedBox(height: 20.h),

              /// Submit
              CustomButton(
                onTap: () {
                  // submit logic
                },
                buttonText: 'Submit',
                imageUrl: 'asets/images/send-alt-1-svgrepo-com.svg',
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Divider(
                            color: AppColors.lightGrey,
                            thickness: 2,
                            endIndent: 20.w)),
                    Text('OR', style: AppTextStyles.bold(24)),
                    Expanded(
                        child: Divider(
                            color: AppColors.lightGrey,
                            thickness: 2,
                            indent: 20.w)),
                  ],
                ),
              ),

              Text(
                'Use voice input to describe the issue—it will auto-fill the title and description.',
                style: AppTextStyles.regular(16),
              ),
              SizedBox(height: 12.h),
              Center(
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                      color: AppColors.darkPink,
                      borderRadius: BorderRadius.circular(100.r)),
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.mic,
                          size: 40.sp, color: AppColors.textColor)),
                ),
              ),
            ]),
          ),
        ),
      ),
      backgroundColor: AppColors.darkBlueGrey,
    );
  }
}
