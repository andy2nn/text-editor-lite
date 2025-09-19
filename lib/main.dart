import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:training_cloud_crm_web/di/injection.dart' as di;
import 'package:training_cloud_crm_web/features/history/history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await di.setup();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HistoryPage());
  }
}
