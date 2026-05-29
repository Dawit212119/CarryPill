import 'package:carrypill/data/repositories/supabase_repo/auth_repo.dart';
import 'package:carrypill/presentations/pages/authenticate/auth_form_widgets.dart';
import 'package:carrypill/presentations/pages/authenticate/forgot_password_dialog.dart';
import 'package:carrypill/presentations/custom_widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/constant_color.dart';

class Login extends StatefulWidget {
  final VoidCallback onGoToSignUp;

  const Login({
    Key? key,
    required this.onGoToSignUp,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with InputValidationMixin, AuthValidators {
  final emailcon = TextEditingController();
  final passcon = TextEditingController();
  final nodeemail = FocusNode();
  final nodepass = FocusNode();

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  String error = '';

  @override
  void dispose() {
    emailcon.dispose();
    passcon.dispose();
    nodeemail.dispose();
    nodepass.dispose();
    super.dispose();
  }

  Future<void> _handleAuthResult(dynamic result) async {
    if (!mounted) return;
    if (result == true) {
      setState(() => loading = false);
      return;
    }
    setState(() {
      loading = false;
      error = result is String
          ? result
          : 'Something went wrong. Please try again.';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFE53935),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: kctextDark,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Sign in to manage your appointments and orders.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: kcGreyLabel,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 24.h),
                AuthTextField(
                  label: 'Email address',
                  hint: 'you@example.com',
                  controller: emailcon,
                  focusNode: nodeemail,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                ),
                AuthTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: passcon,
                  focusNode: nodepass,
                  icon: Icons.lock_outline_rounded,
                  showVisibilityToggle: true,
                  validator: validatePassword,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: loading ? null : () => showForgotPasswordDialog(context),
                    style: TextButton.styleFrom(
                      foregroundColor: kcPrimary,
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                AuthPrimaryButton(
                  label: 'Sign In',
                  loading: loading,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    setState(() => loading = true);
                    final result =
                        await AuthRepo().login(emailcon.text.trim(), passcon.text);
                    await _handleAuthResult(result);
                  },
                ),
                SizedBox(height: 16.h),
                OutlinedButton(
                  onPressed: loading ? null : widget.onGoToSignUp,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 52.h),
                    foregroundColor: kcPrimary,
                    side: const BorderSide(color: kcPrimary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                AuthTextButton(
                  prefix: 'New here? ',
                  action: 'Sign up',
                  onTap: loading ? null : widget.onGoToSignUp,
                ),
              ],
            ),
          ),
        ),
        if (loading)
          Container(
            color: Colors.black26,
            child: const Center(
              child: CircularProgressIndicator(color: kcPrimary),
            ),
          ),
      ],
    );
  }
}
