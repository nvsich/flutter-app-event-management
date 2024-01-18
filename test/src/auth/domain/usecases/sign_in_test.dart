import 'package:cursach_app/src/auth/domain/entities/local_user.dart';
import 'package:cursach_app/src/auth/domain/repos/auth_repo.dart';
import 'package:cursach_app/src/auth/domain/usecases/sign_in.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late SignIn usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignIn(repo);
  });

  const tParams = SignInParams(email: 'tEmail', password: 'tPassword');
  const tLocalUser = LocalUser.empty();

  test('should call [AuthRepo.signIn] and return [LocalUser]', () async {
    when(
      () => repo.signIn(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((invocation) async => const Right(tLocalUser));

    final result = await usecase(tParams);

    expect(result, equals(const Right<dynamic, LocalUser>(tLocalUser)));

    verify(() => repo.signIn(email: tParams.email, password: tParams.password))
        .called(1);

    verifyNoMoreInteractions(repo);
  });
}
