import 'package:flutter/material.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/pages/auth_page.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/pages/settings_page.dart';
import 'package:training_cloud_crm_web/features/history/presintation/pages/history_page.dart';
import 'package:training_cloud_crm_web/features/history/presintation/pages/text_document_page.dart';

class AppNavigator {
  static const String historyPage = '/historyPage';
  static const String textDocumentPage = '/textDocumentPage';
  static const String settingsPage = '/historyPage/settingsPage';
  static const String authPage = 'authPage';

  static Map<String, Widget Function(BuildContext)> routes = {
    authPage: (context) => const AuthPage(),
    historyPage: (context) => const HistoryPage(),
    textDocumentPage: (context) => TextDocumentPage(),
    settingsPage: (context) => SettingsPage(),
  };
}
