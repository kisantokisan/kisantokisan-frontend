import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../design/tokens/tokens.dart';

// Primary pill button (large, rounded)
class PrimaryPillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  const PrimaryPillButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = color ?? Theme.of(context).colorScheme.primary;
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}

// TextFormField with validator, rounded outline, and filled background
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscure;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode? autovalidateMode;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscure = false,
    this.suffix,
    this.validator,
    this.onChanged,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      validator: validator,
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
        ),
        errorMaxLines: 2,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

// Password field with show/hide toggle and validation
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode? autovalidateMode;

  const PasswordField({
    super.key,
    required this.controller,
    this.hint = 'Password',
    this.validator,
    this.onChanged,
    this.autovalidateMode,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      hint: widget.hint,
      obscure: _obscure,
      validator: widget.validator,
      onChanged: widget.onChanged,
      autovalidateMode: widget.autovalidateMode,
      suffix: IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
      ),
    );
  }
}

// Generic social button + brand factories
class SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  final BorderSide? side;
  final VoidCallback? onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    this.side,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: side ?? BorderSide.none,
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        icon: FaIcon(icon, size: 20),
        label: Text(label),
      ),
    );
  }

  factory SocialButton.facebook({VoidCallback? onPressed}) => SocialButton(
    icon: FontAwesomeIcons.facebookF,
    label: 'Sign in with Facebook',
    bg: const Color(0xFF3B5998),
    fg: Colors.white,
    onPressed: onPressed,
  );

  factory SocialButton.twitter({VoidCallback? onPressed}) => SocialButton(
    icon: FontAwesomeIcons.twitter,
    label: 'Sign in with Twitter',
    bg: const Color(0xFF1DA1F2),
    fg: Colors.white,
    onPressed: onPressed,
  );

  factory SocialButton.google({VoidCallback? onPressed}) => SocialButton(
    icon: FontAwesomeIcons.google,
    label: 'Sign in with Google',
    bg: Colors.white,
    fg: Colors.black87,
    side: BorderSide(color: Colors.grey.shade300),
    onPressed: onPressed,
  );

  factory SocialButton.apple({VoidCallback? onPressed}) => SocialButton(
    icon: FontAwesomeIcons.apple,
    label: 'Sign in with Apple',
    bg: Colors.black,
    fg: Colors.white,
    onPressed: onPressed,
  );
}
