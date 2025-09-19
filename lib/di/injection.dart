import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

final getIt = GetIt.instance;
const String textsBox = 'texts_box';

Future<void> setup() async {
  final Box box = await Hive.openBox(textsBox);

  getIt.registerLazySingleton<Box>(() => box);
}
