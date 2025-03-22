import 'package:complaints/core/constants.dart';
import 'package:complaints/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ComplaintFormScreen extends StatefulWidget {
  const ComplaintFormScreen({super.key});

  @override
  ComplaintFormScreenState createState() => ComplaintFormScreenState();
}

class ComplaintFormScreenState extends State<ComplaintFormScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController otherCategoryController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedCategory;
  List<XFile>? selectedImages;
  final ImagePicker picker = ImagePicker();

  final List<String> categories = [
    'Billing',
    'Service',
    'Technical',
    'Product Quality',
    'Delivery',
    'Customer Support',
    'Other'
  ];

  Future<void> pickImages() async {
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      setState(() => selectedImages = images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text('File a Complaint',
              style: AppTextStyles.bold(20, color: AppColors.textColor)),
          backgroundColor: Colors.transparent),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  style: AppTextStyles.regular(18),
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
                  onChanged: (value) =>
                      setState(() => selectedCategory = value),
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
                        labelStyle: AppTextStyles.medium(16,
                            color: AppColors.textColor),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: pickImages,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkPink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                      ),
                      child: Text('Upload Images',
                          style: AppTextStyles.medium(14,
                              color: AppColors.textColor)),
                    ),
                    if (selectedImages != null && selectedImages!.isNotEmpty)
                      Text('${selectedImages!.length} selected',
                          style: AppTextStyles.medium(14,
                              color: AppColors.lightGrey)),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomButton(
                    onTap: () {},
                    buttonText: 'Submit',
                    imageUrl: 'asets/images/send-alt-1-svgrepo-com.svg'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.lightGrey,
                          thickness: 2,
                          endIndent: 20.w,
                        ),
                      ),
                      Text(
                        'OR',
                        style: AppTextStyles.bold(24),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.lightGrey,
                          thickness: 2,
                          indent: 20.w,
                        ),
                      )
                    ],
                  ),
                ),
                Text(
                  'Use voice input to describe the issue—it will auto-fill the title and description.',
                  style: AppTextStyles.regular(16),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                        color: AppColors.darkPink,
                        borderRadius: BorderRadius.circular(100.r)),
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.mic,
                          size: 40.sp,
                          color: AppColors.textColor,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.darkBlueGrey,
    );
  }
}
