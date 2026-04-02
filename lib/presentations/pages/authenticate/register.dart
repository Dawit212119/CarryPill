import 'package:carrypill/data/models/patient.dart';
import 'package:carrypill/data/repositories/supabase_repo/auth_repo.dart';
import 'package:carrypill/presentations/pages/authenticate/auth_form_widgets.dart';
import 'package:carrypill/presentations/custom_widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/constant_color.dart';

class Register extends StatefulWidget {
  final VoidCallback onGoToSignIn;

  const Register({
    Key? key,
    required this.onGoToSignIn,
  }) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
    with InputValidationMixin, AuthValidators {
  final namecon = TextEditingController();
  final emailcon = TextEditingController();
  final pass1con = TextEditingController();
  final pass2con = TextEditingController();
  final icNumcon = TextEditingController();
  final phoneNumcon = TextEditingController();

  final nodename = FocusNode();
  final nodeemail = FocusNode();
  final nodepass1 = FocusNode();
  final nodepass2 = FocusNode();
  final nodeicNum = FocusNode();
  final nodephoneNum = FocusNode();

  String error = '';
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    namecon.dispose();
    emailcon.dispose();
    pass1con.dispose();
    pass2con.dispose();
    icNumcon.dispose();
    phoneNumcon.dispose();
    nodename.dispose();
    nodeemail.dispose();
    nodepass1.dispose();
    nodepass2.dispose();
    nodeicNum.dispose();
    nodephoneNum.dispose();
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

  Patient _buildPatient() {
    return Patient(
      name: namecon.text.trim(),
      icNum: icNumcon.text.trim(),
      phoneNum: phoneNumcon.text.trim(),
      clinicList: AuthRepo.defaultClinicList(),
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
                  'Create account',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: kctextDark,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Join CarryPill to book medication delivery and pickup.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: kcGreyLabel,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 20.h),
                const AuthSectionTitle(
                  title: 'ACCOUNT',
                  subtitle: 'Used to sign in securely',
                ),
                AuthTextField(
                  label: 'Full name',
                  hint: 'As on your ID',
                  controller: namecon,
                  focusNode: nodename,
                  icon: Icons.person_outline_rounded,
                  validator: validateName,
                ),
                AuthTextField(
                  label: 'Email address',
                  hint: 'you@example.com',
                  controller: emailcon,
                  focusNode: nodeemail,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                ),
                const AuthSectionTitle(
                  title: 'SECURITY',
                  subtitle: 'Choose a strong password',
                ),
                AuthTextField(
                  label: 'Password',
                  hint: 'At least 6 characters',
                  controller: pass1con,
                  focusNode: nodepass1,
                  icon: Icons.lock_outline_rounded,
                  showVisibilityToggle: true,
                  validator: validatePassword,
                  onChanged: (_) => setState(() {}),
                ),
                AuthTextField(
                  label: 'Confirm password',
                  hint: 'Re-enter your password',
                  controller: pass2con,
                  focusNode: nodepass2,
                  icon: Icons.lock_reset_rounded,
                  showVisibilityToggle: true,
                  validator: (value) =>
                      validateConfirmPassword(pass1con.text, value),
                  onChanged: (_) => setState(() {}),
                ),
                PasswordMatchHint(
                  password: pass1con.text,
                  confirmPassword: pass2con.text,
                ),
                const AuthSectionTitle(
                  title: 'PERSONAL DETAILS',
                  subtitle: 'For your patient profile',
                ),
                AuthTextField(
                  label: 'IC number',
                  hint: 'National ID / IC',
                  controller: icNumcon,
                  focusNode: nodeicNum,
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: validateIc,
                ),
                AuthTextField(
                  label: 'Phone number',
                  hint: 'e.g. 0123456789',
                  controller: phoneNumcon,
                  focusNode: nodephoneNum,
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: validatePhone,
                ),
                SizedBox(height: 8.h),
                AuthPrimaryButton(
                  label: 'Create Account',
                  loading: loading,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    setState(() => loading = true);
                    final result = await AuthRepo().register(
                      _buildPatient(),
                      emailcon.text.trim(),
                      pass1con.text,
                    );
                    await _handleAuthResult(result);
                  },
                ),
                SizedBox(height: 20.h),
                AuthTextButton(
                  prefix: 'Already have an account? ',
                  action: 'Sign in',
                  onTap: loading ? null : widget.onGoToSignIn,
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
