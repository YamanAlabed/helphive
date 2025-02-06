class Validations {

  // Validate Email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "E-Mail darf nicht leer sein";
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return "Ungültige E-Mail-Adresse";
    }
    return null;
  }
    // Validate Password
    static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Passwort darf nicht leer sein";
    if (value.length < 6) return "Passwort muss mindestens 6 Zeichen lang sein";
    return null;
  }
  // Validate Not Empty
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName darf nicht leer sein";
    }
    return null;
  }
  // Validate Phone Number
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) return "Telefonnummer darf nicht leer sein";
    if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) {
      return "Ungültige Telefonnummer";
    }
    return null;
  }
  // Validate Positive Number
  static String? validatePositiveNumber(String? value) {
    if (value == null || value.isEmpty) return "Dieses Feld darf nicht leer sein";
    final number = num.tryParse(value);
    if (number == null || number <= 0) return "Bitte eine gültige Zahl größer als 0 eingeben";
    return null;
  }
}
