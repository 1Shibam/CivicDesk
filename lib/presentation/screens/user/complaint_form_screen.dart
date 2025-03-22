import 'package:complaints/core/constants.dart';
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

  final List<String> categories = ['Billing', 'Service', 'Technical', 'Other'];

  Future<void> pickImages() async {
    final List<XFile>? images = await picker.pickMultiImage();
    if (images != null) {
      setState(() => selectedImages = images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('File a Complaint', style: AppTextStyles.bold(20))),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration:
                      const InputDecoration(labelText: 'Title of Complaint'),
                  validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                ),
                SizedBox(height: 16.h),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  value: selectedCategory,
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
                if (selectedCategory == 'Other')
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: TextFormField(
                      controller: otherCategoryController,
                      decoration: const InputDecoration(
                          labelText: 'Specify Other Category'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter category' : null,
                    ),
                  ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 5,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a description' : null,
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: pickImages,
                      child: Text('Upload Images',
                          style: AppTextStyles.medium(14)),
                    ),
                    if (selectedImages != null && selectedImages!.isNotEmpty)
                      Text('${selectedImages!.length} selected',
                          style: AppTextStyles.medium(14,
                              color: AppColors.lightGrey)),
                  ],
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Handle submission logic
                    }
                  },
                  child:
                      Text('Submit Complaint', style: AppTextStyles.bold(16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
