import 'package:cursach_app/core/common/app/providers/user_provider.dart';
import 'package:cursach_app/core/common/widgets/gradient_background.dart';
import 'package:cursach_app/core/common/widgets/rounded_button.dart';
import 'package:cursach_app/core/extensions/context_extension.dart';
import 'package:cursach_app/core/res/media_res.dart';
import 'package:cursach_app/core/utils/core_utils.dart';
import 'package:cursach_app/src/auth/data/models/local_user_model.dart';
import 'package:cursach_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:cursach_app/src/auth/presentation/bloc/auth_event.dart';
import 'package:cursach_app/src/auth/presentation/bloc/auth_state.dart';
import 'package:cursach_app/src/auth/presentation/views/sign_up_screen.dart';
import 'package:cursach_app/src/auth/presentation/widgets/sign_in_form.dart';
import 'package:cursach_app/src/dashboard/presentation/views/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedIn) {
            context.read<UserProvider>().initUser(state.user as LocalUserModel);
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
          }
        },
        builder: (context, state) {
          return GradientBackground(
            image: MediaRes.authBackground,
            child: SafeArea(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const Text(
                    'AUTH TEXT',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sign in to your account',
                        style: TextStyle(fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            SignUpScreen.routeName,
                          );
                        },
                        child: const Text('Register?'),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  SignInForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    formKey: formKey,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/reset-password');
                      },
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (state is AuthLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    RoundedButton(
                      label: 'SignIn',
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        FirebaseAuth.instance.currentUser?.reload();
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                SignInEvent(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                ),
                              );
                        }
                      },
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
