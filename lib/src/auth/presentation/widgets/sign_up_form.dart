import 'package:cursach_app/core/common/widgets/input_field.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.fullNameController,
    required this.formKey,
    super.key,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController fullNameController;
  final GlobalKey<FormState> formKey;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          InputField(
            controller: widget.fullNameController,
            hintText: 'Full Name',
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 25),
          InputField(
            controller: widget.emailController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 25),
          InputField(
            controller: widget.passwordController,
            hintText: 'Password',
            obscureText: obscurePassword,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscurePassword = !obscurePassword;
                });
              },
              icon: Icon(
                obscurePassword ? Icons.apple : Icons.holiday_village_rounded,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 25),
          InputField(
            controller: widget.confirmPasswordController,
            hintText: 'Confirm Password',
            obscureText: obscureConfirmPassword,
            keyboardType: TextInputType.visiblePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  obscureConfirmPassword = !obscureConfirmPassword;
                });
              },
              icon: Icon(
                obscurePassword ? Icons.android : Icons.holiday_village_rounded,
                color: Colors.grey,
              ),
            ),
            validator: (value) {
              if (value != widget.passwordController.text) {
                return 'Passwords have to match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
