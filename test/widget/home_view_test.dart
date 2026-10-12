import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techtest/app/data/models/item_model.dart';
import 'package:techtest/app/data/models/user_model.dart';
import 'package:techtest/app/data/repositories/auth_repository.dart';
import 'package:techtest/app/data/repositories/item_repository.dart';
import 'package:techtest/app/modules/home/controllers/home_controller.dart';
import 'package:techtest/app/modules/home/views/home_view.dart';

class MockItemRepository extends Mock implements IItemRepository {}
class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockItemRepository mockItemRepository;
  late MockAuthRepository mockAuthRepository;

  const sampleItems = [
    ItemModel(
      id: '1',
      title: 'OpenAPI Gateway',
      description: 'Centralized microservices reverse proxy',
      category: 'Cloud',
      price: 250.0,
    ),
    ItemModel(
      id: '2',
      title: 'Auth Vault',
      description: 'Encrypted token storage manager',
      category: 'Security',
      price: 180.0,
    ),
  ];

  setUp(() {
    Get.reset();
    mockItemRepository = MockItemRepository();
    mockAuthRepository = MockAuthRepository();

    when(() => mockAuthRepository.getCurrentUser()).thenAnswer(
      (_) async => const UserModel(
        id: '1',
        name: 'M. Ilham Rigan Agachi',
        email: 'maachigan@gmail.com',
      ),
    );
    when(() => mockItemRepository.getItems()).thenAnswer((_) async => sampleItems);

    Get.put<IItemRepository>(mockItemRepository);
    Get.put<IAuthRepository>(mockAuthRepository);
    Get.put<HomeController>(
      HomeController(
        itemRepository: mockItemRepository,
        authRepository: mockAuthRepository,
      ),
    );
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('HomeView renders item list, FAB, and user session info',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomeView(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Data Management (CRUD)'), findsOneWidget);
    expect(find.text('OpenAPI Gateway'), findsOneWidget);
    expect(find.text('Auth Vault'), findsOneWidget);
    expect(find.byKey(const Key('add_item_fab')), findsOneWidget);
    expect(find.byKey(const Key('logout_button')), findsOneWidget);
  });

  testWidgets('Clicking delete button opens confirmation dialog',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: HomeView(),
      ),
    );

    await tester.pumpAndSettle();

    final deleteIcon = find.byIcon(Icons.delete_outline_rounded).first;
    await tester.tap(deleteIcon);
    await tester.pumpAndSettle();

    expect(find.text('Konfirmasi Hapus'), findsOneWidget);
    expect(find.text('Hapus Data'), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);
  });
}
