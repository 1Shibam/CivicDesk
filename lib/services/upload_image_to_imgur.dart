import 'dart:io';
import 'package:complaints/presentation/widgets/custom_snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> uploadImageToImgur(BuildContext context, File imageFile) async {
  try {
    final Dio dio = Dio(BaseOptions(
        baseUrl: 'https://api.imgur.com/3',
        sendTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5)));
    final cliendId = dotenv.env['IMGUR_CLIENT_ID'];
    if (cliendId == null || cliendId.isEmpty) {
      throw Exception("Error - IMGUR_CLIENT_ID is missing");
    }

    //preparing headers -
    final headers = {'Authorization': 'Client-ID $cliendId'};
    //Preparing form data -
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: 'profileUpload.jpg',
      ),
      'type': 'image',
      'title': 'Profile Picture',
      'description': 'uploaded via quick Chat App'
    });

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        return handler.next(e);
      },
    ));

    final response = await dio.post('/image',
        data: formData, options: Options(headers: headers));

    if (response.statusCode == 200) {
      final String imageUrl = response.data['data']['link'];
      return imageUrl;
    } else {
      return null;
    }
  } catch (e) {
    if (context.mounted) {
      customSnackbar(
          context: context,
          message: 'Something went wrong to imgur',
          bgColor: Colors.red,
          iconName: Icons.error);
    }
    rethrow;
  }
}
