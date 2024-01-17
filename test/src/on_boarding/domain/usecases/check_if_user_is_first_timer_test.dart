import 'package:cursach_app/src/on_boarding/domain/usecases/check_if_user_is_first_timer.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'on_boarding_repo.mock.dart';

void main() {
  late MockOnBoardingRepo repo;
  late CheckIfUserIsFirstTimer usecase;

  setUp(() {
    repo = MockOnBoardingRepo();
    usecase = CheckIfUserIsFirstTimer(repo);
  });

  test('should get a response from the [MockOnBoardingRepo]', () async {
    when(() => repo.checkIfUserIsFirstTimer()).thenAnswer(
      (invocation) async => const Right(true),
    );

    final result = await usecase();

    expect(result, equals(const Right<dynamic, bool>(true)));
    verify(() => repo.checkIfUserIsFirstTimer()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
