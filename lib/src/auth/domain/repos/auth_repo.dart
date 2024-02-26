import 'package:cursach_app/core/enums/update_user_action.dart';
import 'package:cursach_app/core/utils/typedefs.dart';
import 'package:cursach_app/src/auth/domain/entities/local_user.dart';

abstract class AuthRepo {
  const AuthRepo();

  ResultFuture<void> resetPassword(String email);

  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  });

  ResultFuture<void> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });
}
