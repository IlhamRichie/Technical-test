import 'package:flutter_test/flutter_test.dart';
import 'package:techtest/app/data/models/item_model.dart';
import 'package:techtest/app/data/models/user_model.dart';

void main() {
  group('UserModel Serialization', () {
    test('correctly parses JSON to UserModel and vice versa', () {
      final jsonMap = {
        'id': 'u101',
        'name': 'M. Ilham Rigan Agachi',
        'email': 'maachigan@gmail.com',
        'avatarUrl': 'https://example.com/avatar.png',
        'token': 'mock-jwt-token',
      };

      final user = UserModel.fromJson(jsonMap);

      expect(user.id, 'u101');
      expect(user.name, 'M. Ilham Rigan Agachi');
      expect(user.email, 'maachigan@gmail.com');
      expect(user.avatarUrl, 'https://example.com/avatar.png');
      expect(user.token, 'mock-jwt-token');

      final serialized = user.toJson();
      expect(serialized['id'], 'u101');
      expect(serialized['email'], 'maachigan@gmail.com');
      expect(serialized['token'], 'mock-jwt-token');
    });

    test('handles fallback keys such as avatar_url', () {
      final jsonMap = {
        'id': 'u102',
        'name': 'Test User',
        'email': 'test@domain.com',
        'avatar_url': 'https://example.com/avatar2.png',
      };

      final user = UserModel.fromJson(jsonMap);
      expect(user.avatarUrl, 'https://example.com/avatar2.png');
    });
  });

  group('ItemModel Serialization', () {
    test('correctly parses JSON to ItemModel and serializes back', () {
      final fixedDate = DateTime.parse('2026-10-11T12:00:00.000Z');
      final jsonMap = {
        'id': 'itm-99',
        'title': 'Test Item Title',
        'description': 'Description of test item',
        'category': 'Testing',
        'price': 125.50,
        'createdAt': fixedDate.toIso8601String(),
      };

      final item = ItemModel.fromJson(jsonMap);

      expect(item.id, 'itm-99');
      expect(item.title, 'Test Item Title');
      expect(item.description, 'Description of test item');
      expect(item.category, 'Testing');
      expect(item.price, 125.50);
      expect(item.createdAt, isNotNull);

      final serialized = item.toJson();
      expect(serialized['id'], 'itm-99');
      expect(serialized['price'], 125.50);
      expect(serialized['category'], 'Testing');
    });

    test('copyWith updates properties properly', () {
      const item = ItemModel(
        id: '1',
        title: 'Original Title',
        description: 'Original Desc',
        category: 'Cat A',
        price: 100.0,
      );

      final updated = item.copyWith(title: 'Updated Title', price: 150.0);
      expect(updated.id, '1');
      expect(updated.title, 'Updated Title');
      expect(updated.description, 'Original Desc');
      expect(updated.price, 150.0);
    });
  });
}
