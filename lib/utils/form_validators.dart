class FormValidators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Email Address';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid Email Address';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? passwordOnlyRequiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Password';
    }

    return null;
  }

  static String? confirmPasswordValidator(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your Password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? requiredFieldValidator(String? value,
      {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty ';
    }
    return null;
  }

  static String? fullNameValidator(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Please enter your Full Name';
    }
    if (trimmed.length < 2) {
      return 'Full Name must be at least 2 characters long';
    }
    if (trimmed.length > 50) {
      return 'Full Name must not exceed 50 characters';
    }
    return null;
  }
}
