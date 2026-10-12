class Validators {
  Validators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$',
  );

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!_emailRegExp.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < minLength) {
      return 'Password minimal $minLength karakter';
    }
    return null;
  }

  static String? validateRequired(String? value, [String fieldName = 'Bidang ini']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  static String? validateNumber(String? value, [String fieldName = 'Nilai']) {
    final requiredError = validateRequired(value, fieldName);
    if (requiredError != null) return requiredError;

    final parsed = num.tryParse(value!.trim());
    if (parsed == null) {
      return '$fieldName harus berupa angka yang valid';
    }
    if (parsed <= 0) {
      return '$fieldName harus lebih besar dari 0';
    }
    return null;
  }
}
