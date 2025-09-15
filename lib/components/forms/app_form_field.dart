import 'package:flutter/material.dart';

/// Reusable form field component
class AppFormField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final String? helperText;
  final IconData? prefixIcon;
  final bool obscureText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const AppFormField({
    super.key,
    required this.labelText,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.obscureText = false,
    this.initialValue,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      validator: validator,
    );
  }
}
