import 'package:bloc/bloc.dart';
import 'package:cursach_app/src/auth/domain/usecases/reset_password.dart';
import 'package:cursach_app/src/auth/domain/usecases/sign_in.dart';
import 'package:cursach_app/src/auth/domain/usecases/sign_up.dart';
import 'package:cursach_app/src/auth/domain/usecases/update_user.dart';
import 'package:cursach_app/src/auth/presentation/bloc/auth_event.dart';
import 'package:cursach_app/src/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required UpdateUser updateUser,
    required ResetPassword resetPassword,
  })  : _signIn = signIn,
        _signUp = signUp,
        _updateUser = updateUser,
        _resetPassword = resetPassword,
        super(const AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });
    on<SignInEvent>(_signInHandler);
    on<SignUpEvent>(_signUpHandler);
    on<ResetPasswordEvent>(_resetPasswordHandler);
    on<UpdateUserEvent>(_updateUserHandler);
  }

  final SignIn _signIn;
  final SignUp _signUp;
  final UpdateUser _updateUser;
  final ResetPassword _resetPassword;

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (user) => emit(SignedIn(user)),
    );
  }

  Future<void> _signUpHandler(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signUp(
      SignUpParams(
        email: event.email,
        password: event.password,
        fullName: event.name,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const SignedUp()),
    );
  }

  Future<void> _resetPasswordHandler(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _resetPassword(event.email);

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const ResetPasswordSent()),
    );
  }

  Future<void> _updateUserHandler(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _updateUser(
      UpdateUserParams(
        action: event.action,
        userData: event.userData,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const UserUpdated()),
    );
  }
}
