import 'package:flutter/material.dart';
import 'package:helphive_flutter/core/services/auth_service.dart';
import 'package:helphive_flutter/core/theme/colors.dart';
import 'package:helphive_flutter/core/theme/styles.dart';
import 'package:helphive_flutter/core/widgets/custom_button.dart';
import 'package:helphive_flutter/core/widgets/custom_error_message.dart';
import 'package:helphive_flutter/core/widgets/custom_input_field.dart';
import 'package:helphive_flutter/core/widgets/loading_spinner.dart';
import 'package:helphive_flutter/features/auth/reset_password.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: colorSoftWhite,
              title: const Text(
                'Flutter',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
            backgroundColor: colorSoftWhite,
            body: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'In Ihr Konto einloggen',
                    style: largeBoldTextStyle(context),
                  ),
                  const SizedBox(height: 80),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'E-Mail',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Passwort',
                    icon: Icons.lock,
                    obscureText: _obscurePassword,
                    toggleVisibility: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CustomErrorMessage(errorMessage: _errorMessage!),
                    ),
                  const SizedBox(height: 60),
                  Align(
                    alignment: Alignment.center,
                    child: CustomButton(
                      text: 'Einloggen',
                      onPressed: _handleSignIn,
                      type: ButtonType.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildAdditionalOptions(),
                ],
              ),
            ),
          );
  }

  Future<void> _handleSignIn() async {
    setState(() => loading = true);
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    setState(() => _errorMessage = null);

    String? errorMessage =
        await _auth.signInWithEmailAndPasswordWithValidation(email, password);
    if (errorMessage != null) {
      _showError(errorMessage);
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
      loading = false;
    });
  }

  Widget _buildAdditionalOptions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgotPassword()),
          ),
          child: Text(
            'Passwort vergessen?',
            style: normalTextStyle(context).copyWith(
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Noch kein Konto?', style: normalTextStyle(context)),
            TextButton(
              onPressed: () => widget.toggleView(),
              child: Text(
                'Jetzt registrieren!',
                style: normalTextStyle(context).copyWith(
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
