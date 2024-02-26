import 'package:cursach_app/core/errors/exceptions.dart';
import 'package:cursach_app/core/errors/failures.dart';
import 'package:cursach_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:cursach_app/src/on_boarding/data/repos/on_boarding_repo_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnBoardingLocalDataSource extends Mock
    implements OnBoardingLocalDataSource {}

void main() {
  late OnBoardingRepoImpl repoImpl;
  late OnBoardingLocalDataSource localDataSource;

  setUp(() {
    localDataSource = MockOnBoardingLocalDataSource();
    repoImpl = OnBoardingRepoImpl(localDataSource);
  });

  group('cacheFirstTimer', () {
    test(
      'should complete successfully when call to localDataSource is successful',
      () async {
        when(() => localDataSource.cacheFirstTimer()).thenAnswer(
          (invocation) async => Future.value(),
        );

        final result = await repoImpl.cacheFirstTimer();

        expect(result, equals(const Right<dynamic, void>(null)));
        verify(() => localDataSource.cacheFirstTimer()).called(1);
        verifyNoMoreInteractions(localDataSource);
      },
    );
  });

  test(
    'should return [CacheFailure] when call to localDataSource is failed',
    () async {
      when(() => localDataSource.cacheFirstTimer()).thenThrow(
        const CacheException(message: 'Insufficient Storage Space'),
      );

      final result = await repoImpl.cacheFirstTimer();

      expect(
        result,
        equals(
          Left<CacheFailure, dynamic>(
            CacheFailure(
              message: 'Insufficient Storage Space',
              statusCode: 500,
            ),
          ),
        ),
      );
      verify(() => localDataSource.cacheFirstTimer()).called(1);
      verifyNoMoreInteractions(localDataSource);
    },
  );

  group(
    'checkIfUserIsFirstTimer',
    () {
      test(
        'should return correct data when call to localDataSource is '
        'successful',
        () async {
          when(() => localDataSource.checkIfUserIsFirstTimer()).thenAnswer(
            (invocation) async => Future.value(true),
          );

          final result = await repoImpl.checkIfUserIsFirstTimer();

          expect(result, equals(const Right<dynamic, bool>(true)));
          verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);
          verifyNoMoreInteractions(localDataSource);
        },
      );

      test(
        'should return correct data when call to localDataSource is '
        'successful',
        () async {
          when(() => localDataSource.checkIfUserIsFirstTimer()).thenAnswer(
            (invocation) async => Future.value(false),
          );

          final result = await repoImpl.checkIfUserIsFirstTimer();

          expect(result, equals(const Right<dynamic, bool>(false)));
          verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);
          verifyNoMoreInteractions(localDataSource);
        },
      );

      test(
        'should return [CacheException] when call to localDataSource is failed',
        () async {
          when(() => localDataSource.checkIfUserIsFirstTimer()).thenThrow(
            const CacheException(message: 'Insufficient Storage Space'),
          );

          final result = await repoImpl.checkIfUserIsFirstTimer();

          expect(
            result,
            equals(
              Left<CacheFailure, dynamic>(
                CacheFailure(
                  message: 'Insufficient Storage Space',
                  statusCode: 500,
                ),
              ),
            ),
          );

          verify(() => localDataSource.checkIfUserIsFirstTimer()).called(1);
          verifyNoMoreInteractions(localDataSource);
        },
      );
    },
  );
}
