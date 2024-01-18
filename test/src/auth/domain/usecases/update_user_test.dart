import 'package:cursach_app/core/enums/update_user_action.dart';
import 'package:cursach_app/src/auth/domain/repos/auth_repo.dart';
import 'package:cursach_app/src/auth/domain/usecases/update_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepo repo;
  late UpdateUser usecase;

  setUp(() {
    repo = MockAuthRepo();
    usecase = UpdateUser(repo);
  });

  const tParams = UpdateUserParams.empty();

  test('should call [AuthRepo.updateUser]', () async {
    when(
      () => repo.updateUser(
        action: UpdateUserAction.fullname,
        userData: any<String>(named: 'userData'),
      ),
    ).thenAnswer((invocation) async => const Right(null));

    final result = await usecase(tParams);

    expect(result, equals(const Right<dynamic, void>(null)));

    verify(
      () => repo.updateUser(action: tParams.action, userData: tParams.userData),
    ).called(1);

    verifyNoMoreInteractions(repo);
  });
}
