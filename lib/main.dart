import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:training_cloud_crm_web/app.dart';
import 'package:training_cloud_crm_web/core/di/injection.dart';
import 'package:training_cloud_crm_web/core/untils/constans.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  await Injection.setup();

  runApp(const App());
}
