import 'package:cursach_app/src/auth/domain/entities/local_user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class SignedIn extends AuthState {
  const SignedIn(this.user);

  final LocalUser user;

  @override
  List<Object> get props => [user];
}

class SignedUp extends AuthState {
  const SignedUp();
}

class ResetPasswordSent extends AuthState {
  const ResetPasswordSent();
}

class UserUpdated extends AuthState {
  const UserUpdated();
}

class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
