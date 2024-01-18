import 'package:cursach_app/core/usecases/usecases.dart';
import 'package:cursach_app/core/utils/typedefs.dart';
import 'package:cursach_app/src/auth/domain/repos/auth_repo.dart';
import 'package:equatable/equatable.dart';

class SignUp extends UsecaseWithParams<void, SignUpParams> {
  const SignUp(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(SignUpParams params) => _repo.signUp(
        email: params.email,
        password: params.password,
        fullname: params.fullname,
      );
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.password,
    required this.fullname,
  });

  const SignUpParams.empty()
      : this(
          email: '',
          password: '',
          fullname: '',
        );

  final String email;
  final String password;
  final String fullname;

  @override
  List<String> get props => [email, password, fullname];
}
