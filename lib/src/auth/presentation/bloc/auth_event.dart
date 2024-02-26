import 'dart:io';

import 'package:cursach_app/core/enums/update_user_action.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignInEvent extends AuthEvent {
  const SignInEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<String> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  const SignUpEvent({
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;

  @override
  List<String> get props => [email, password, name];
}

class ResetPasswordEvent extends AuthEvent {
  const ResetPasswordEvent(this.email);

  final String email;

  @override
  List<String> get props => [email];
}

class UpdateUserEvent extends AuthEvent {
  UpdateUserEvent({
    required this.action,
    required this.userData,
  }) : assert(
          userData is String || userData is File,
          '[userData] must be either a String or a File, '
          'but ${userData.runtimeType} was provided',
        );

  final UpdateUserAction action;
  final dynamic userData;

  @override
  List<Object?> get props => [action, userData];
}
