import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:training_cloud_crm_web/app.dart';
import 'package:training_cloud_crm_web/core/di/injection.dart' as di;
import 'package:training_cloud_crm_web/core/untils/constans.dart';
import 'package:training_cloud_crm_web/features/auth/domain/auth_repository.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_event.dart';
import 'package:training_cloud_crm_web/features/history/domain/documents_repository.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  await di.setup();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(authRepository: di.getIt.get<AuthRepository>())
                ..add(AuthStatusChecked()),
        ),
        BlocProvider(
          create: (context) => TextDocumentBloc(
            docRepository: di.getIt.get<DocumentsRepository>(),
          ),
        ),
      ],
      child: const App(),
    ),
  );
}
