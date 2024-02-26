import 'package:cursach_app/core/common/widgets/input_field.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          InputField(
            controller: widget.emailController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(
            height: 25,
          ),
          InputField(
            controller: widget.passwordController,
            hintText: 'Password',
            obscureText: obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.woman_2 : Icons.woman_2_rounded,
                color: Colors.grey,
              ),
              onPressed: () => setState(() {
                obscurePassword = !obscurePassword;
              }),
            ),
          )
        ],
      ),
    );
  }
}
