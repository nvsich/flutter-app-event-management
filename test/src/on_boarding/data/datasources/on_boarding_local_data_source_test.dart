import 'package:cursach_app/core/errors/exceptions.dart';
import 'package:cursach_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences preferences;
  late OnBoardingLocalDataSource localDataSource;

  setUp(() {
    preferences = MockSharedPreferences();
    localDataSource = OnBoardingLocalDataSourceImpl(preferences);
  });

  group('cacheFirstTimer', () {
    test(
      'should call [SharedPreferences] to cache the data',
      () async {
        when(() => preferences.setBool(any(), any()))
            .thenAnswer((invocation) async => true);

        await localDataSource.cacheFirstTimer();

        verify(() => preferences.setBool(kFirstTimerKey, false)).called(1);
        verifyNoMoreInteractions(preferences);
      },
    );

    test(
      'should throw a [CacheException] when there is an error caching the data',
      () async {
        when(() => preferences.setBool(any(), any())).thenThrow(Exception());

        final call = localDataSource.cacheFirstTimer;

        expect(call, throwsA(isA<CacheException>()));
        verify(() => preferences.setBool(kFirstTimerKey, false)).called(1);
        verifyNoMoreInteractions(preferences);
      },
    );
  });

  group(
    'checkIfUserIsFirstTimer',
    () {
      test(
        'should call [SharedPreferences] to check if User is first timer and '
        'return the right response from storage when data exists',
        () async {
          when(() => preferences.getBool(any())).thenReturn(false);

          final result = await localDataSource.checkIfUserIsFirstTimer();

          expect(result, false);
          verify(() => preferences.getBool(kFirstTimerKey));
          verifyNoMoreInteractions(preferences);
        },
      );

      test(
        'should return true if storage is empty',
        () async {
          when(() => preferences.getBool(any())).thenReturn(null);

          final result = await localDataSource.checkIfUserIsFirstTimer();

          expect(result, true);
          verify(() => preferences.getBool(kFirstTimerKey));
          verifyNoMoreInteractions(preferences);
        },
      );

      test(
        'should throw a [CacheException] when there is an error '
        'getting the data',
        () async {
          when(() => preferences.getBool(any())).thenThrow(Exception());

          final call = localDataSource.checkIfUserIsFirstTimer;

          expect(call, throwsA(isA<CacheException>()));
          verify(() => preferences.getBool(kFirstTimerKey)).called(1);
          verifyNoMoreInteractions(preferences);
        },
      );
    },
  );
}
