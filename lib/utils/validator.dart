class AppValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name required';
    return null;
  }

  static String? validateCompany(String? value) {
    if (value == null || value.trim().isEmpty) return 'Company name required';
    return null;
  }

  static String? validateDomain(String? value) {
    if (value == null || value.trim().isEmpty) return 'Domain required';

    // Lowercase and trim to avoid simple user errors
    final cleanValue = value.trim().toLowerCase();

    // This Regex ensures at least: word.word
    final domainRegex = RegExp(r'^([a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,}$');

    if (!domainRegex.hasMatch(cleanValue)) {
      return 'Invalid domain (e.g., company.com)';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Invalid email';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password required';
    return null;
  }

  // app_validators.dart
  static String? validateConfirmPassword(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password required';
    }
    if (password != confirmPassword) return 'password did not match';
    return null;
  }
}
