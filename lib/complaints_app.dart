import 'package:complaints/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'routes/router_config.dart';

class ComplaintsApp extends StatelessWidget {
  const ComplaintsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      //base design size
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        //using go router
        return MaterialApp.router(
          routerConfig: appRoutes,
          theme: appTheme,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
