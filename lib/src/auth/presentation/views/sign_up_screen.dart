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
import 'package:cursach_app/src/auth/presentation/views/sign_in_screen.dart';
import 'package:cursach_app/src/auth/presentation/widgets/sign_up_form.dart';
import 'package:cursach_app/src/dashboard/presentation/views/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as fui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
          } else if (state is SignedUp) {
            context.read<AuthBloc>().add(
                  SignInEvent(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                );
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
                    'SIGN UP TEXT',
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
                        'Sign up for an account',
                        style: TextStyle(fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            SignInScreen.routeName,
                          );
                        },
                        child: const Text('Already have an account?'),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  SignUpForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                    fullNameController: fullNameController,
                    formKey: formKey,
                  ),
                  const SizedBox(height: 30),
                  if (state is AuthLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    RoundedButton(
                      label: 'Sign Up',
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        FirebaseAuth.instance.currentUser?.reload();
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                SignUpEvent(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  name: fullNameController.text.trim(),
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
