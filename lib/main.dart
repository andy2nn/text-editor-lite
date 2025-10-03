import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:training_cloud_crm_web/app.dart';
import 'package:training_cloud_crm_web/core/di/injection.dart';
import 'package:training_cloud_crm_web/core/untils/constans.dart';
import 'package:app_links/app_links.dart';
import 'package:training_cloud_crm_web/features/history/domain/documents_repository.dart';
import 'package:training_cloud_crm_web/features/history/domain/entity/text_document_entity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  await Injection.setup();

  await _initDeepLinks();

  runApp(const App());
}

Future<void> _initDeepLinks() async {
  final appLinks = AppLinks();

  final initialUri = await appLinks.getInitialLink();
  if (initialUri != null) {
    _handleDeepLink(initialUri);
  }

  appLinks.uriLinkStream.listen((Uri uri) {
    _handleDeepLink(uri);
  });
}

void _handleDeepLink(Uri uri) {
  if (uri.scheme == 'io.supabase.flutterquickstart') {
    if (uri.host == 'document' || uri.host == 'open') {
      _navigateToDocumentFromDeepLink(uri);
    }
  }
}

void _navigateToDocumentFromDeepLink(Uri uri) {
  final document = TextDocumentEntity.fromDeepLink(uri);
  Injection.getIt.get<DocumentsRepository>().saveDocument(document, null);
}
