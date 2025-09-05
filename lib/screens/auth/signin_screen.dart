import 'package:flutter/material.dart';
import '../../design/tokens/tokens.dart';
import '../../widgets/components.dart';
import '../../data/auth_repository.dart';

enum SignFlow { login, create }

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  // NOTE: this can be phone or email (kept name for minimal changes)
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  // Added for Create flow
  final _fullName = TextEditingController();
  final _optionalEmail = TextEditingController();

  final _auth = AuthRepository();

  SignFlow _flow = SignFlow.login;
  bool _submitting = false;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _fullName.dispose();
    _optionalEmail.dispose();
    super.dispose();
  }

  bool _isEmail(String v) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim());
  bool _isPhone(String v) => RegExp(r'^[0-9]{10,}$').hasMatch(v.trim());

  bool get _idLooksEmail => _isEmail(_email.text.trim());

  String? _validateIdentifier(String? v) {
    final text = (v ?? '').trim();
    if (text.isEmpty) return 'Required';
    if (!_isEmail(text) && !_isPhone(text)) {
      return 'Enter a valid email or mobile number';
    }
    return null;
  }

  String? _validatePassword(String? v) {
    final text = (v ?? '').trim();
    if (text.isEmpty) return 'Required';
    if (text.length < 6) return 'At least 6 characters';
    return null;
  }

  String? _validateConfirm(String? v) {
    if (_flow != SignFlow.create) return null;
    final text = (v ?? '').trim();
    if (text.isEmpty) return 'Confirm your password';
    if (text != _password.text.trim()) return 'Passwords do not match';
    return null;
  }

  String? _validateFullName(String? v) {
    if (_flow != SignFlow.create) return null;
    final text = (v ?? '').trim();
    if (text.length < 3) return 'Enter your full name';
    return null;
  }

  String? _validateOptionalEmail(String? v) {
    // Only when creating AND identifier is a phone AND user typed something
    if (_flow != SignFlow.create) return null;
    if (_idLooksEmail) return null;
    final text = (v ?? '').trim();
    if (text.isEmpty) return null;
    return _isEmail(text) ? null : 'Enter a valid email';
  }

  Future<void> _handlePrimary() async {
    // Validate all visible fields
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _submitting = true);
    final id = _email.text.trim();
    final pw = _password.text.trim();

    try {
      if (_flow == SignFlow.login) {
        // Try to sign in
        final res = await _auth.signIn(id, pw);
        if (res == AuthResult.success) {
          if (mounted)
            Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
        } else if (res == AuthResult.userNotFound) {
          setState(() => _flow = SignFlow.create);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No account found — create one now.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wrong password. Try again.')),
          );
        }
      } else {
        // Create account
        if (!_termsAccepted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please accept the Terms & Privacy Policy.'),
            ),
          );
          return;
        }

        // Decide which optional fields to pass:
        final String? email = _idLooksEmail
            ? id
            : (_optionalEmail.text.trim().isEmpty
                  ? null
                  : _optionalEmail.text.trim());
        final String? phone = _idLooksEmail ? null : id;

        // IMPORTANT: extend your AuthRepository.createAccount to accept these named params.
        final res = await _auth.createAccount(
          id,
          pw,
          fullName: _fullName.text.trim(),
          email: email,
          phone: phone,
        );

        if (res == AuthResult.success) {
          if (mounted)
            Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email/phone already in use.')),
          );
        }
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final isCreate = _flow == SignFlow.create;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isCreate ? 'Create Account' : 'Sign In'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xl),
                Text(
                  isCreate ? 'Create Account' : 'Sign In',
                  style: t.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Identifier: email or phone
                AppTextField(
                  controller: _email,
                  hint: 'Mobile Number or Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateIdentifier,
                  onChanged: (_) =>
                      setState(() {}), // updates _idLooksEmail-dependent UI
                ),
                const SizedBox(height: AppSpacing.md),

                // Password
                PasswordField(
                  controller: _password,
                  hint: 'Password',
                  validator: _validatePassword,
                ),
                const SizedBox(height: AppSpacing.md),

                // Extra fields in Create mode
                if (isCreate) ...[
                  // Confirm password
                  PasswordField(
                    controller: _confirm,
                    hint: 'Confirm password',
                    validator: _validateConfirm,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Full name
                  AppTextField(
                    controller: _fullName,
                    hint: 'Full Name',
                    validator: _validateFullName,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Optional email only when identifier is a phone number
                  if (!_idLooksEmail) ...[
                    AppTextField(
                      controller: _optionalEmail,
                      hint: 'Email (optional)',
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateOptionalEmail,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Terms & Privacy checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _termsAccepted,
                        onChanged: (v) =>
                            setState(() => _termsAccepted = v ?? false),
                      ),
                      const Expanded(
                        child: Text('I agree to the Terms & Privacy Policy'),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: AppSpacing.lg),

                // Primary action
                PrimaryPillButton(
                  label: isCreate ? 'Create account' : 'Sign In',
                  onPressed: _submitting ? null : _handlePrimary,
                ),

                const SizedBox(height: AppSpacing.md),

                // Forgot password (only in Sign In view)
                if (!isCreate)
                  TextButton(
                    onPressed: _submitting
                        ? null
                        : () => Navigator.pushNamed(context, '/forgot'),
                    child: const Text('Forgot password?'),
                  ),

                // Toggle link between Sign In and Create
                TextButton(
                  onPressed: _submitting
                      ? null
                      : () => setState(() {
                          _flow = isCreate ? SignFlow.login : SignFlow.create;
                        }),
                  child: Text(
                    isCreate
                        ? 'Have an account? Sign in'
                        : 'Create a new account',
                  ),
                ),

                const SizedBox(height: AppSpacing.xl * 1.5),

                // Social buttons (keep your existing behavior)
                SocialButton.facebook(onPressed: _submitting ? null : () {}),
                const SizedBox(height: AppSpacing.md),
                SocialButton.twitter(onPressed: _submitting ? null : () {}),
                const SizedBox(height: AppSpacing.md),
                SocialButton.google(onPressed: _submitting ? null : () {}),
                const SizedBox(height: AppSpacing.md),
                SocialButton.apple(onPressed: _submitting ? null : () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
