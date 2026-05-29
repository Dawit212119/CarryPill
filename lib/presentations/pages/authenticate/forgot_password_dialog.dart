import 'package:carrypill/constants/constant_color.dart';
import 'package:carrypill/data/repositories/supabase_repo/auth_repo.dart';
import 'package:carrypill/presentations/custom_widgets/text_input_field.dart';
import 'package:carrypill/presentations/pages/authenticate/auth_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _ForgotPasswordValidators with InputValidationMixin, AuthValidators {}

Future<void> showForgotPasswordDialog(BuildContext context) async {
  final validators = _ForgotPasswordValidators();
  final emailController = TextEditingController();
  final emailFocus = FocusNode();
  final formKey = GlobalKey<FormState>();
  var loading = false;

  await showDialog<void>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            title: Text(
              'Reset password',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: kctextDark),
            ),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'We\'ll email you a link to set a new password.',
                    style: TextStyle(fontSize: 13.sp, color: kcGreyLabel, height: 1.4),
                  ),
                  SizedBox(height: 16.h),
                  AuthTextField(
                    label: 'Email address',
                    hint: 'you@example.com',
                    controller: emailController,
                    focusNode: emailFocus,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: validators.validateEmail,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: loading ? null : () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: loading
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        setDialogState(() => loading = true);
                        final result = await AuthRepo()
                            .resetPassword(emailController.text.trim());
                        if (!context.mounted) return;
                        setDialogState(() => loading = false);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result == true
                                  ? 'Check your email for the reset link.'
                                  : (result as String? ?? 'Could not send reset email.'),
                            ),
                          ),
                        );
                      },
                child: loading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send link'),
              ),
            ],
          );
        },
      );
    },
  );

  emailController.dispose();
  emailFocus.dispose();
}
