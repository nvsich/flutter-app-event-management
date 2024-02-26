import 'package:cursach_app/core/usecases/usecases.dart';
import 'package:cursach_app/core/utils/typedefs.dart';
import 'package:cursach_app/src/auth/domain/repos/auth_repo.dart';

class ResetPassword extends UsecaseWithParams<void, String> {
  const ResetPassword(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(String params) async => _repo.resetPassword(params);
}
