import 'package:flutter/material.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/pages/auth_page.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/pages/settings_page.dart';
import 'package:training_cloud_crm_web/features/history/presintation/history_page.dart';
import 'package:training_cloud_crm_web/features/history/presintation/text_document_page.dart';

class AppNavigator {
  static String historyPage = '/history';
  static String textDocumentPage = '/textDocumentPage';
  static String settingsPage = '/settings';
  static String authPage = 'auth';

  static Map<String, Widget Function(BuildContext)> routes = {
    'auth': (context) => const AuthPage(),
    '/history': (context) => const HistoryPage(),
    '/textDocumentPage': (context) => TextDocumentPage(),
    '/settings': (context) => SettingsPage(),
  };
}
