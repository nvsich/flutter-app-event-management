import 'package:cursach_app/core/errors/exceptions.dart';
import 'package:cursach_app/core/errors/failures.dart';
import 'package:cursach_app/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:cursach_app/src/auth/data/models/local_user_model.dart';
import 'package:cursach_app/src/auth/data/repos/auth_repo_impl.dart';
import 'package:cursach_app/src/auth/domain/entities/local_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRemoteDataSource remoteDataSource;
  late AuthRepoImpl repo;

  const tEmail = '';
  const tPassword = '';

  const tLocalUserModel = LocalUserModel.empty();

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSource();
    repo = AuthRepoImpl(remoteDataSource);
  });

  group('AuthRepoImpl', () {
    group('resetPassword', () {
      test(
          'should return correct data when call to remote data source '
          'is successful', () async {
        when(() => remoteDataSource.resetPassword(any()))
            .thenAnswer((invocation) async => const Right<Failure, void>(null));

        final result = await repo.resetPassword(tEmail);

        expect(result, equals(const Right<dynamic, void>(null)));
        verify(() => remoteDataSource.resetPassword(tEmail)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      });

      test(
          'should return [ServerFailure] when call to remote data source '
          'is unsuccessful', () async {
        when(() => remoteDataSource.resetPassword(any())).thenThrow(
          const ServerException(
            message: 'Server Error Occurred',
            statusCode: '505',
          ),
        );

        final result = await repo.resetPassword(tEmail);

        expect(
          result,
          equals(
            Left<ServerFailure, dynamic>(
              ServerFailure(
                message: 'Server Error Occurred',
                statusCode: '505',
              ),
            ),
          ),
        );

        verify(() => remoteDataSource.resetPassword(tEmail)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      });
    });

    group('signIn', () {
      test(
          'should return correct data when call to remote data source '
          'is successful', () async {
        when(
          () => remoteDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((invocation) async => tLocalUserModel);

        final result = await repo.signIn(email: tEmail, password: tPassword);

        expect(
          result,
          equals(
            const Right<dynamic, LocalUser>(tLocalUserModel),
          ),
        );
        verify(
          () => remoteDataSource.signIn(email: tEmail, password: tPassword),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      });

      test(
          'should return [ServerFailure] when call to remote data source '
          'is unsuccessful', () async {
        when(
          () => remoteDataSource.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(
          const ServerException(
            message: 'Server Error Occurred',
            statusCode: '505',
          ),
        );

        final result = await repo.signIn(email: tEmail, password: tPassword);

        expect(
          result,
          equals(
            Left<ServerFailure, dynamic>(
              ServerFailure(
                message: 'Server Error Occurred',
                statusCode: '505',
              ),
            ),
          ),
        );
      });
    });
  });
}
