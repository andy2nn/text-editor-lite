import 'package:flutter/material.dart';
import 'package:training_cloud_crm_web/core/untils/app_navigator.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: AppNavigator.routes,
      initialRoute: AppNavigator.authPage,
      debugShowCheckedModeBanner: false,
    );
  }
}
