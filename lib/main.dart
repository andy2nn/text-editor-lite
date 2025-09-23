import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:training_cloud_crm_web/core/di/injection.dart' as di;
import 'package:training_cloud_crm_web/features/auth/domain/auth_repository.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/bloc/auth_event.dart';
import 'package:training_cloud_crm_web/features/auth/presentation/pages/auth_page.dart';
import 'package:training_cloud_crm_web/features/history/presintation/history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Supabase.initialize(
    url: "https://uxftqpnpezjjgfjfxtge.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV4ZnRxcG5wZXpqamdmamZ4dGdlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgyNzA0MDYsImV4cCI6MjA3Mzg0NjQwNn0.V4YuUHiZvwLOrSClW5QNYWlRs9RZd096ohwJlf3q3L4",
  );

  await di.setup();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(authRepository: di.getIt.get<AuthRepository>())
                ..add(AuthStatusChecked()),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'auth': (context) => const AuthPage(),
        '/history': (context) => const HistoryPage(),
      },
      initialRoute: 'auth',
    );
  }
}
