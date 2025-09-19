import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:training_cloud_crm_web/core/untils/constans.dart';
import 'package:training_cloud_crm_web/features/auth/data/auth_repository_impl.dart';
import 'package:training_cloud_crm_web/features/auth/domain/auth_repository.dart';

final getIt = GetIt.instance;
final supabase = Supabase.instance.client;

Future<void> setup() async {
  final Box box = await Hive.openBox(textsBox);

  getIt.registerLazySingleton<Box>(() => box);
  getIt.registerLazySingleton<SupabaseClient>(() => supabase);
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(supabase),
  );
}
