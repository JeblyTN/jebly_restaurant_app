import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant/controller/splash_controller.dart';
import 'package:restaurant/themes/app_them_data.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/ic_logo.png"),
                  const SizedBox(height: 10),
                  Text(
                    "Welcome to Jebly Restaurant".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: AppThemeData.bold),
                  ),
                  Text(
                    "Your Favorite Food Delivered Fast!".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87, fontSize: 12, fontFamily: AppThemeData.regular),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
