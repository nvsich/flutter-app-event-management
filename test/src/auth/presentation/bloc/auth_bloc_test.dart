import 'package:bloc_test/bloc_test.dart';
import 'package:cursach_app/core/errors/failures.dart';
import 'package:cursach_app/src/auth/data/models/local_user_model.dart';
import 'package:cursach_app/src/auth/domain/usecases/reset_password.dart';
import 'package:cursach_app/src/auth/domain/usecases/sign_in.dart';
import 'package:cursach_app/src/auth/domain/usecases/sign_up.dart';
import 'package:cursach_app/src/auth/domain/usecases/update_user.dart';
import 'package:cursach_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:cursach_app/src/auth/presentation/bloc/auth_event.dart';
import 'package:cursach_app/src/auth/presentation/bloc/auth_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSignIn extends Mock implements SignIn {}

class MockSignUp extends Mock implements SignUp {}

class MockResetPassword extends Mock implements ResetPassword {}

class MockUpdateUser extends Mock implements UpdateUser {}

void main() {
  late SignIn signIn;
  late SignUp signUp;
  late ResetPassword resetPassword;
  late UpdateUser updateUser;
  late AuthBloc authBloc;

  const tSignInParams = SignInParams.empty();
  const tSignUpParams = SignUpParams.empty();
  const tUpdateUserParams = UpdateUserParams.empty();

  final tServerFailure = ServerFailure(
    message: 'user-not-found',
    statusCode: 'There is no user',
  );

  setUp(() {
    signIn = MockSignIn();
    signUp = MockSignUp();
    resetPassword = MockResetPassword();
    updateUser = MockUpdateUser();
    authBloc = AuthBloc(
      signIn: signIn,
      signUp: signUp,
      updateUser: updateUser,
      resetPassword: resetPassword,
    );
  });

  setUpAll(() {
    registerFallbackValue(tSignUpParams);
    registerFallbackValue(tSignInParams);
    registerFallbackValue(tUpdateUserParams);
  });

  tearDown(() => authBloc.close());

  test('initial state should be [AuthInitial]', () async {
    expect(authBloc.state, const AuthInitial());
  });

  group('SignInEvent', () {
    const tUser = LocalUserModel.empty();

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedIn] when signIn is successful',
      build: () {
        when(() => signIn(any()))
            .thenAnswer((invocation) async => const Right(tUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => {
        const AuthLoading(),
        const SignedIn(tUser),
      },
      verify: (bloc) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when signIn failed',
      build: () {
        when(() => signIn(any())).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignInEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
        ),
      ),
      expect: () => {
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      },
      verify: (bloc) {
        verify(() => signIn(tSignInParams)).called(1);
        verifyNoMoreInteractions(signIn);
      },
    );
  });

  group('SignUpEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, SignedUp] when signUp is successful',
      build: () {
        when(() => signUp(any()))
            .thenAnswer((invocation) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
          name: tSignUpParams.fullName,
        ),
      ),
      expect: () => {
        const AuthLoading(),
        const SignedUp(),
      },
      verify: (bloc) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when signUp failed',
      build: () {
        when(() => signUp(any())).thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        SignUpEvent(
          email: tSignInParams.email,
          password: tSignInParams.password,
          name: tSignUpParams.fullName,
        ),
      ),
      expect: () => {
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      },
      verify: (bloc) {
        verify(() => signUp(tSignUpParams)).called(1);
        verifyNoMoreInteractions(signUp);
      },
    );
  });

  group('ResetPasswordEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, ResetPasswordSent] when ResetPassword succeed',
      build: () {
        when(() => resetPassword(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const ResetPasswordEvent('email'),
      ),
      expect: () => {
        const AuthLoading(),
        const ResetPasswordSent(),
      },
      verify: (bloc) {
        verify(() => resetPassword('email')).called(1);
        verifyNoMoreInteractions(resetPassword);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when ResetPassword succeed',
      build: () {
        when(() => resetPassword(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const ResetPasswordEvent('email'),
      ),
      expect: () => {
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      },
      verify: (bloc) {
        verify(() => resetPassword('email')).called(1);
        verifyNoMoreInteractions(resetPassword);
      },
    );
  });

  group('UpdateUserEvent', () {
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, UserUpdated] when UpdateUserEvent succeed',
      build: () {
        when(() => updateUser(any()))
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserParams.action,
          userData: tUpdateUserParams.userData,
        ),
      ),
      expect: () => {
        const AuthLoading(),
        const UserUpdated(),
      },
      verify: (bloc) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when UpdateUserEvent failed',
      build: () {
        when(() => updateUser(any()))
            .thenAnswer((_) async => Left(tServerFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        UpdateUserEvent(
          action: tUpdateUserParams.action,
          userData: tUpdateUserParams.userData,
        ),
      ),
      expect: () => {
        const AuthLoading(),
        AuthError(tServerFailure.errorMessage),
      },
      verify: (bloc) {
        verify(() => updateUser(tUpdateUserParams)).called(1);
        verifyNoMoreInteractions(updateUser);
      },
    );
  });
}
