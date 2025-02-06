import 'package:flutter/material.dart';
import 'package:helphive_flutter/core/services/auth_service.dart';
import 'package:helphive_flutter/core/theme/colors.dart';
import 'package:helphive_flutter/core/widgets/custom_button.dart';
import 'package:helphive_flutter/core/widgets/custom_error_message.dart';
import 'package:helphive_flutter/core/widgets/custom_input_field.dart';
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  String? _errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 80),
              const Text(
                'Bitte E-Mail eingeben. Sie erhalten dann eine E-Mail mit einem Link zum Zurücksetzen des Passworts.',
                style: TextStyle(
                  fontSize: 26,
                  color: colorDarkGray,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              CustomTextField(
                controller: _emailController,
                labelText: 'E-Mail',
                icon: Icons.email,
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                CustomErrorMessage(
                  errorMessage: _errorMessage!,
                ),
              const SizedBox(height: 80),
              Align(
                alignment: Alignment.center,
                child: CustomButton(
                  text: 'Passwort zurücksetzen',
                  onPressed: () async {
                    String email = _emailController.text.trim();
                    setState(() => _errorMessage = null);
                    if (email.isEmpty) {
                      setState(() {
                        _errorMessage = 'Bitte füllen Sie alle Felder aus!';
                      });
                      return;
                    }
                    if (!_auth.isValidEmail(email)) {
                      setState(() {
                        _errorMessage =
                            'Bitte geben Sie eine gültige E-Mail-Adresse ein!';
                      });
                      return;
                    }
                    dynamic result = await _auth.passwordReset(email);
                    if (result == null) {
                      setState(() => _errorMessage =
                          'Bitte schauen Sie in Ihrem E-Mail-Fach nach.');
                    } else {
                      setState(() => _errorMessage =
                          'Bitte überprüfen Sie die E-Mail auf Richtigkeit.');
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
