import 'package:flutter/material.dart';
import 'package:helphive_flutter/core/services/auth_service.dart';
import 'package:helphive_flutter/core/theme/colors.dart';
import 'package:helphive_flutter/core/widgets/custom_button.dart';
import 'package:helphive_flutter/core/widgets/custom_error_message.dart';
import 'package:helphive_flutter/core/widgets/custom_input_field.dart';
import 'package:helphive_flutter/core/widgets/loading_spinner.dart';

class Register extends StatefulWidget {
  const Register({super.key, required this.toggleView});
  final Function toggleView;
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Create an instance of AuthService
  final AuthService _auth = AuthService();
  // Create a TextEditingController for the email, password, username, and confirm password fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
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
                '',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF242736)),
                onPressed: () {
                  widget.toggleView();
                },
              ),
            ),
            backgroundColor: colorSoftWhite,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Erstellen Sie Jetzt ein Konto',
                      style: TextStyle(
                        fontSize: 45,
                        color: colorDarkGray,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 80),
                    CustomTextField(
                      controller: _usernameController,
                      labelText: 'Benutzername',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'E-Mail',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                      controller: _passwordController,
                      labelText: 'Passwort',
                      icon: Icons.lock,
                      obscureText: _obscurePassword,
                      toggleVisibility: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      labelText: 'Passwort bestätigen',
                      icon: Icons.lock,
                      obscureText: _obscurePassword,
                    ),
                    const SizedBox(height: 80),
                    CustomButton(
                      text: 'Registrieren',
                      onPressed: () async {
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        String username = _usernameController.text.trim();
                        String confirmPassword =
                            _confirmPasswordController.text.trim();
                        setState(() {
                          _errorMessage = null;
                        });
                        setState(() => loading = true);
                        // Felder prüfen
                        if (email.isEmpty ||
                            password.isEmpty ||
                            confirmPassword.isEmpty ||
                            username.isEmpty) {
                          setState(() {
                            _errorMessage = 'Bitte füllen Sie alle Felder aus.';
                            loading = false;
                          });
                          return;
                        }
                        if (!_auth.isValidEmail(email)) {
                          setState(() {
                            _errorMessage =
                                'Bitte geben Sie eine gültige E-Mail-Adresse ein.';
                            loading = false;
                          });
                          return;
                        }
                        // Passwortstärke prüfen
                        if (!_auth.isValidPassword(password)) {
                          setState(() {
                            _errorMessage =
                                'Das Passwort muss mindestens 10 Zeichen lang sein und mindestens einen Buchstaben sowie eine Zahl enthalten.';
                            loading = false;
                          });
                          return;
                        }
                        // Passwort und Bestätigungspasswort prüfen
                        if (!_auth.doPasswordsMatch(
                            password, confirmPassword)) {
                          setState(() {
                            _errorMessage =
                                'Die Passwörter stimmen nicht überein.';
                            loading = false;
                          });
                          return;
                        }
                        // Registrierung durchführen
                        dynamic result =
                            await _auth.registerWithEmailAndPassword(
                                email, password, username);
                        if (result == null) {
                          setState(() {
                            _errorMessage =
                                'Bitte verwenden Sie eine gültige E-Mail-Adresse und ein Passwort, das die Anforderungen erfüllt.';
                            loading = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    // Display the error message
                    if (_errorMessage != null)
                      CustomErrorMessage(
                        errorMessage: _errorMessage!,
                      ),
                  ],
                ),
              ),
            ),
          );
  }
}
