import 'package:bloc_test/bloc_test.dart';
import 'package:cursach_app/core/errors/failures.dart';
import 'package:cursach_app/src/on_boarding/domain/usecases/cache_first_timer.dart';
import 'package:cursach_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:cursach_app/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCacheFirstTimer extends Mock implements CacheFirstTimer {}

class MockCheckIfUserIsFirstTimer extends Mock
    implements CheckIfUserIsFirstTimer {}

void main() {
  final tCacheFailure = CacheFailure(
    message: 'Insufficient storage permission',
    statusCode: 4032,
  );

  late CacheFirstTimer cacheFirstTimer;
  late CheckIfUserIsFirstTimer checkIfUserIsFirstTimer;
  late OnBoardingCubit cubit;

  setUp(() {
    cacheFirstTimer = MockCacheFirstTimer();
    checkIfUserIsFirstTimer = MockCheckIfUserIsFirstTimer();
    cubit = OnBoardingCubit(
      cacheFirstTimer: cacheFirstTimer,
      checkIfUserIsFirstTimer: checkIfUserIsFirstTimer,
    );
  });

  tearDown(() => cubit.close());

  test('initial state should be [OnBoardingInitial]', () async {
    expect(cubit.state, const OnBoardingInitial());
  });

  group(
    'cacheFirstTimer',
    () {
      blocTest<OnBoardingCubit, OnBoardingState>(
        'should emit [CachingFirstTimer, UserCached] when successful',
        build: () {
          when(() => cacheFirstTimer()).thenAnswer(
            (invocation) async => const Right(null),
          );
          return cubit;
        },
        act: (cubit) => cubit.cacheFirstTimer(),
        expect: () => const [
          CachingFirstTimer(),
          UserCached(),
        ],
        verify: (cubit) {
          verify(() => cacheFirstTimer()).called(1);
          verifyNoMoreInteractions(cacheFirstTimer);
        },
      );

      blocTest<OnBoardingCubit, OnBoardingState>(
        'should emit [CachingFirstTimerUser, OnBoardingError] '
        'when unsuccessful',
        build: () {
          when(() => cacheFirstTimer()).thenAnswer(
            (invocation) async => Left(tCacheFailure),
          );
          return cubit;
        },
        act: (cubit) => cubit.cacheFirstTimer(),
        expect: () => [
          const CachingFirstTimer(),
          OnBoardingError(tCacheFailure.errorMessage),
        ],
        verify: (cubit) {
          verify(() => cacheFirstTimer()).called(1);
          verifyNoMoreInteractions(cacheFirstTimer);
        },
      );
    },
  );

  group(
    'checkIfUserIsFirstTimer',
    () {
      blocTest<OnBoardingCubit, OnBoardingState>(
        'should emit [CheckingIfUserIsFirstTimer, OnBoardingStatus] '
        'when successful',
        build: () {
          when(() => checkIfUserIsFirstTimer())
              .thenAnswer((invocation) async => const Right(false));
          return cubit;
        },
        act: (cubit) => cubit.checkIfUserIsFirstTimer(),
        expect: () => const [
          CheckingIfUserIsFirstTimer(),
          OnBoardingStatus(isFirstTimer: false),
        ],
        verify: (cubit) {
          verify(() => checkIfUserIsFirstTimer()).called(1);
          verifyNoMoreInteractions(checkIfUserIsFirstTimer);
        },
      );

      blocTest<OnBoardingCubit, OnBoardingState>(
        'should emit [CheckingIfUserIsFirstTimer, OnBoardingStatus] '
        'when unsuccessful',
        build: () {
          when(() => checkIfUserIsFirstTimer())
              .thenAnswer((invocation) async => Left(tCacheFailure));
          return cubit;
        },
        act: (cubit) => cubit.checkIfUserIsFirstTimer(),
        expect: () => const [
          CheckingIfUserIsFirstTimer(),
          OnBoardingStatus(isFirstTimer: true),
        ],
        verify: (cubit) {
          verify(() => checkIfUserIsFirstTimer()).called(1);
          verifyNoMoreInteractions(checkIfUserIsFirstTimer);
        },
      );
    },
  );
}
