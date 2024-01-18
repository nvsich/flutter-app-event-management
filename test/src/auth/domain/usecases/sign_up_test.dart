import 'package:cursach_app/src/auth/domain/repos/auth_repo.dart';
import 'package:cursach_app/src/auth/domain/usecases/sign_up.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late SignUp usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignUp(repo);
  });

  const tParams = SignUpParams.empty();

  test('should call [AuthRepo.signUp]', () async {
    when(
      () => repo.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        fullname: any(named: 'fullname'),
      ),
    ).thenAnswer((invocation) async => const Right(null));

    final result = await usecase(tParams);

    expect(result, equals(const Right<dynamic, void>(null)));

    verify(
      () => repo.signUp(
        email: tParams.email,
        password: tParams.password,
        fullname: tParams.fullname,
      ),
    ).called(1);
    verifyNoMoreInteractions(repo);
  });
}
