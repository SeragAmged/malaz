class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String? password) {
    if (value?.isEmpty ?? true) {
      return 'Confirm password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Password is required';
    }
    if (value!.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validateDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Display name is required';
    }
    if (value.length < 3) {
      return 'Display name must be at least 3 characters';
    }
    return null;
  }

  static String? validateEmpty(String? value, String errorString) =>
      (value == null || value.trim().isEmpty) ? errorString : null;
}
