import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:training_cloud_crm_web/core/untils/constans.dart';
import 'package:training_cloud_crm_web/features/auth/data/auth_repository_impl.dart';
import 'package:training_cloud_crm_web/features/auth/domain/auth_repository.dart';
import 'package:training_cloud_crm_web/features/history/data/datasources/local_documents_source.dart';
import 'package:training_cloud_crm_web/features/history/data/datasources/remote_documents_source.dart';
import 'package:training_cloud_crm_web/features/history/data/documents_repository_impl.dart';
import 'package:training_cloud_crm_web/features/history/domain/documents_repository.dart';
import 'package:training_cloud_crm_web/features/history/domain/model/text_document_model.dart';

final getIt = GetIt.instance;
final supabase = Supabase.instance.client;

Future<void> setup() async {
  Hive.registerAdapter(TextDocumentModelAdapter());
  final box = await Hive.openBox<TextDocumentModel>(textsBox);

  getIt.registerLazySingleton<Box>(() => box);
  getIt.registerLazySingleton<SupabaseClient>(() => supabase);

  getIt.registerLazySingleton<LocalDocumentsSource>(
    () => LocalDocumentsSource(box),
  );
  getIt.registerLazySingleton<RemoteDocumentsSource>(
    () => RemoteDocumentsSource(supabase),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(supabase),
  );

  getIt.registerLazySingleton<DocumentsRepository>(
    () => DocumentsRepositoryImpl(
      local: getIt.get<LocalDocumentsSource>(),
      remote: getIt.get<RemoteDocumentsSource>(),
    ),
  );
}
