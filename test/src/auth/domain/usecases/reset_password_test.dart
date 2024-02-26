import 'package:cursach_app/src/auth/domain/repos/auth_repo.dart';
import 'package:cursach_app/src/auth/domain/usecases/reset_password.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late ResetPassword usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = ResetPassword(repo);
  });

  const tEmail = '';

  test('should call [AuthRepo.resetPassword]', () async {
    when(() => repo.resetPassword(any()))
        .thenAnswer((invocation) async => const Right(null));

    final result = await usecase(tEmail);

    expect(result, equals(const Right<dynamic, void>(null)));

    verify(() => repo.resetPassword(tEmail)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
