import 'package:flutter_test/flutter_test.dart';
import 'package:techtest/app/core/utils/validators.dart';

void main() {
  group('Validators Test - Email Validation', () {
    test('returns error when email is null or empty', () {
      expect(Validators.validateEmail(null), 'Email tidak boleh kosong');
      expect(Validators.validateEmail(''), 'Email tidak boleh kosong');
      expect(Validators.validateEmail('   '), 'Email tidak boleh kosong');
    });

    test('returns error for invalid email formats', () {
      expect(Validators.validateEmail('user'), 'Format email tidak valid');
      expect(Validators.validateEmail('user@'), 'Format email tidak valid');
      expect(Validators.validateEmail('user@domain'), 'Format email tidak valid');
      expect(Validators.validateEmail('@domain.com'), 'Format email tidak valid');
    });

    test('returns null for valid emails', () {
      expect(Validators.validateEmail('user@example.com'), isNull);
      expect(Validators.validateEmail('maachigan@gmail.com'), isNull);
      expect(Validators.validateEmail('user.name+tag@sub.domain.co.id'), isNull);
    });
  });

  group('Validators Test - Password Validation', () {
    test('returns error when password is null or empty', () {
      expect(Validators.validatePassword(null), 'Password tidak boleh kosong');
      expect(Validators.validatePassword(''), 'Password tidak boleh kosong');
    });

    test('returns error when password is shorter than minimum length', () {
      expect(Validators.validatePassword('12345'), 'Password minimal 6 karakter');
      expect(Validators.validatePassword('abc'), 'Password minimal 6 karakter');
    });

    test('returns null when password meets requirements', () {
      expect(Validators.validatePassword('123456'), isNull);
      expect(Validators.validatePassword('securePassword!2026'), isNull);
    });
  });

  group('Validators Test - Required & Numeric Field Validation', () {
    test('returns error when required field is empty', () {
      expect(Validators.validateRequired('', 'Judul'), 'Judul tidak boleh kosong');
      expect(Validators.validateRequired('   ', 'Deskripsi'), 'Deskripsi tidak boleh kosong');
    });

    test('returns null when required field has content', () {
      expect(Validators.validateRequired('Technical Test', 'Judul'), isNull);
    });

    test('validates numbers correctly', () {
      expect(Validators.validateNumber('', 'Harga'), 'Harga tidak boleh kosong');
      expect(Validators.validateNumber('abc', 'Harga'), 'Harga harus berupa angka yang valid');
      expect(Validators.validateNumber('-10', 'Harga'), 'Harga harus lebih besar dari 0');
      expect(Validators.validateNumber('0', 'Harga'), 'Harga harus lebih besar dari 0');
      expect(Validators.validateNumber('150000', 'Harga'), isNull);
      expect(Validators.validateNumber('99.9', 'Harga'), isNull);
    });
  });
}
