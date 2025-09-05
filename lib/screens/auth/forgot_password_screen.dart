import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _id = TextEditingController();

  String? _validateId(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final s = v.trim();
    if (s.contains('@')) {
      final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);
      return ok ? null : 'Enter a valid email';
    } else {
      final digits = s.replaceAll(RegExp(r'\D'), '');
      return (digits.length >= 8 && digits.length <= 14)
          ? null
          : 'Enter a valid phone';
    }
  }

  @override
  void dispose() {
    _id.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const Text('We will send a 6-digit code to your phone or email.'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _id,
                decoration: const InputDecoration(labelText: 'Email or Mobile'),
                validator: _validateId,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Reset code sent (mock)')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Send Reset Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
