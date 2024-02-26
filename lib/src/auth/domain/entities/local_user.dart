// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.fullName,
    this.profilePic,
    this.organizationIds = const [],
  });

  const LocalUser.empty()
      : this(
          uid: '',
          email: '',
          fullName: '',
          profilePic: '',
          organizationIds: const [],
        );

  final String uid;
  final String email;
  final String fullName;
  final String? profilePic;
  final List<String>? organizationIds;

  @override
  List<Object?> get props => [uid, email];

  @override
  String toString() {
    return 'LocalUser{uid: $uid, email: $email, fullname: $fullName }';
  }
}
