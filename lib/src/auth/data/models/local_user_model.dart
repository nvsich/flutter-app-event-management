import 'package:cursach_app/core/utils/typedefs.dart';
import 'package:cursach_app/src/auth/domain/entities/local_user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.fullName,
    super.profilePic,
    super.organizationIds,
  });

  LocalUserModel.fromMap(DataMap map)
      : super(
          uid: map['uid'] as String,
          email: map['email'] as String,
          fullName: map['fullName'] as String,
          profilePic: map['profilePic'] as String?,
          organizationIds:
              (map['organizationIds'] as List<dynamic>).cast<String>(),
        );

  const LocalUserModel.empty()
      : this(
          uid: '',
          email: '',
          fullName: '',
        );

  LocalUserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? profilePic,
    List<String>? organizationIds,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profilePic: profilePic ?? this.profilePic,
      organizationIds: organizationIds ?? this.organizationIds,
    );
  }

  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'profilePic': profilePic,
      'organizationIds': organizationIds,
    };
  }
}
