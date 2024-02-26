import 'package:cursach_app/core/enums/update_user_action.dart';
import 'package:cursach_app/core/errors/exceptions.dart';
import 'package:cursach_app/core/errors/failures.dart';
import 'package:cursach_app/core/utils/typedefs.dart';
import 'package:cursach_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:cursach_app/src/auth/domain/entities/local_user.dart';
import 'package:cursach_app/src/auth/domain/repos/auth_repo.dart';
import 'package:dartz/dartz.dart';

class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> resetPassword(String email) async {
    try {
      await _remoteDataSource.resetPassword(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<LocalUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      await _remoteDataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      await _remoteDataSource.updateUser(action: action, userData: userData);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
