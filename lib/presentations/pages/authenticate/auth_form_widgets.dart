import 'package:carrypill/presentations/custom_widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/constant_color.dart';

class AuthSectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AuthSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: kcPrimary,
              letterSpacing: 0.6,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12.sp,
                color: kcGreyLabel,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AuthTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final IconData icon;
  final bool obscureText;
  final bool showVisibilityToggle;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.focusNode,
    required this.icon,
    this.obscureText = false,
    this.showVisibilityToggle = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _hidden;

  @override
  void initState() {
    super.initState();
    _hidden = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: kctextDark,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: widget.showVisibilityToggle ? _hidden : widget.obscureText,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            style: TextStyle(
              fontSize: 15.sp,
              color: kctextDark,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: kcGreyLabel.withValues(alpha: 0.85),
              ),
              filled: true,
              fillColor: kcBgDark,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              prefixIcon: Icon(
                widget.icon,
                color: kcPrimary.withValues(alpha: 0.75),
                size: 22.sp,
              ),
              suffixIcon: widget.showVisibilityToggle
                  ? IconButton(
                      onPressed: () => setState(() => _hidden = !_hidden),
                      icon: Icon(
                        _hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: kcGreyLabel,
                        size: 22.sp,
                      ),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: kcOutlineTextField),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: kcBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: kcPrimary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFFE53935)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordMatchHint extends StatelessWidget {
  final String password;
  final String confirmPassword;

  const PasswordMatchHint({
    super.key,
    required this.password,
    required this.confirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    if (confirmPassword.isEmpty) return const SizedBox.shrink();

    final matches = password.isNotEmpty && password == confirmPassword;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Row(
        children: [
          Icon(
            matches ? Icons.check_circle_rounded : Icons.error_outline_rounded,
            size: 16.sp,
            color: matches ? const Color(0xFF2E7D32) : const Color(0xFFE53935),
          ),
          SizedBox(width: 6.w),
          Text(
            matches ? 'Passwords match' : 'Passwords do not match',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: matches ? const Color(0xFF2E7D32) : const Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kcPrimary,
          foregroundColor: kcWhite,
          disabledBackgroundColor: kcPrimary.withValues(alpha: 0.5),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: loading
            ? SizedBox(
                width: 22.w,
                height: 22.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: kcWhite,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }
}

class AuthTextButton extends StatelessWidget {
  final String prefix;
  final String action;
  final VoidCallback? onTap;

  const AuthTextButton({
    super.key,
    required this.prefix,
    required this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prefix,
          style: TextStyle(fontSize: 14.sp, color: kcGreyLabel),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            action,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: kcPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Shared validators for auth forms.
mixin AuthValidators on InputValidationMixin {
  String? validateName(String? value) {
    if (!isNameValid(value)) return 'Full name is required';
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  String? validatePassword(String? value) {
    if (!isPasswordValid(value)) return 'Password is required';
    if (!isPasswordValidLength(value)) {
      return 'Use at least 6 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? password, String? confirm) {
    if (confirm == null || confirm.isEmpty) {
      return 'Please confirm your password';
    }
    if (!isConfPasswordValid(password, confirm)) {
      return 'Passwords must match';
    }
    return null;
  }

  String? validateIc(String? value) {
    if (!isIcNumValid(value)) return 'IC number is required';
    return null;
  }

  String? validatePhone(String? value) {
    if (!isphoneNumValid(value)) return 'Phone number is required';
    return null;
  }
}
