import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_cloud_crm_web/core/di/injection.dart';
import 'package:training_cloud_crm_web/core/untils/app_navigator.dart';
import 'package:training_cloud_crm_web/features/auth/domain/auth_repository.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_event.dart';
import 'package:training_cloud_crm_web/features/history/domain/documents_repository.dart';
import 'package:training_cloud_crm_web/features/history/presintation/bloc/text_document_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(authRepository: Injection.getIt.get<AuthRepository>())
                ..add(AuthStatusChecked()),
        ),
        BlocProvider(
          create: (context) => TextDocumentBloc(
            docRepository: Injection.getIt.get<DocumentsRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        routes: AppNavigator.routes,
        initialRoute: AppNavigator.authPage,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
