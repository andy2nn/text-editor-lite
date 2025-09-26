import 'package:hive/hive.dart';
import 'package:training_cloud_crm_web/features/auth/domain/entity/user_entity.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String email;

  UserModel({required this.id, required this.email});

  UserEntity toEntity() => UserEntity(id: id, email: email);

  static UserModel fromEntity(UserEntity entity) =>
      UserModel(id: entity.id, email: entity.email);
}
