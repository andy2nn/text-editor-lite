import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:training_cloud_crm_web/core/untils/constans.dart';
import 'package:training_cloud_crm_web/features/auth/data/auth_repository_impl.dart';
import 'package:training_cloud_crm_web/features/auth/data/datasources/local_auth_source.dart';
import 'package:training_cloud_crm_web/features/auth/domain/auth_repository.dart';
import 'package:training_cloud_crm_web/features/auth/domain/model/user_model.dart';
import 'package:training_cloud_crm_web/features/history/data/datasources/local_documents_source.dart';
import 'package:training_cloud_crm_web/features/history/data/datasources/remote_documents_source.dart';
import 'package:training_cloud_crm_web/features/history/data/documents_repository_impl.dart';
import 'package:training_cloud_crm_web/features/history/domain/documents_repository.dart';
import 'package:training_cloud_crm_web/features/history/domain/model/text_document_model.dart';

class Injection {
  static final getIt = GetIt.instance;
  static final supabase = Supabase.instance.client;

  static Future<void> setup() async {
    Hive.registerAdapter(TextDocumentModelAdapter());
    Hive.registerAdapter(UserModelAdapter());
    final boxLocalAuth = await Hive.openBox<bool>(biometricEnabled);
    final boxDocument = await Hive.openBox<TextDocumentModel>(textsBox);
    final boxUser = await Hive.openBox<UserModel>(userBox);

    getIt.registerLazySingleton(() => boxLocalAuth);
    getIt.registerLazySingleton<Box<UserModel>>(() => boxUser);
    getIt.registerLazySingleton<Box<TextDocumentModel>>(() => boxDocument);
    getIt.registerLazySingleton<SupabaseClient>(() => supabase);

    getIt.registerLazySingleton(() => LocalAuthSource());

    getIt.registerLazySingleton<LocalDocumentsSource>(
      () => LocalDocumentsSource(boxDocument),
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

  static updateDependency() {
    if (getIt.isRegistered<DocumentsRepository>()) {
      getIt.unregister<DocumentsRepository>();
    }
    getIt.registerLazySingleton<DocumentsRepository>(
      () => DocumentsRepositoryImpl(
        local: getIt.get<LocalDocumentsSource>(),
        remote: getIt.get<RemoteDocumentsSource>(),
      ),
    );
  }
}
