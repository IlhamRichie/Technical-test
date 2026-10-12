import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techtest/app/core/services/storage_service.dart';
import 'package:techtest/app/data/models/item_model.dart';
import 'package:techtest/app/data/providers/api_provider.dart';
import 'package:techtest/app/data/repositories/item_repository.dart';

class MockApiProvider extends Mock implements ApiProvider {}
class MockStorageService extends Mock implements StorageService {}
class FakeItemModel extends Fake implements ItemModel {}

void main() {
  late MockApiProvider mockApiProvider;
  late MockStorageService mockStorageService;
  late ItemRepository repository;

  setUpAll(() {
    registerFallbackValue(FakeItemModel());
  });

  setUp(() {
    mockApiProvider = MockApiProvider();
    mockStorageService = MockStorageService();
    repository = ItemRepository(
      apiProvider: mockApiProvider,
      storageService: mockStorageService,
    );
  });

  group('ItemRepository Unit Test with Mocking', () {
    const sampleItem = ItemModel(
      id: '10',
      title: 'Mocked Item',
      description: 'Mocked Description',
      category: 'Mock',
      price: 50.0,
    );

    test('getItems passes token and returns items from provider', () async {
      when(() => mockStorageService.getToken()).thenAnswer((_) async => 'mock-token');
      when(() => mockApiProvider.getItems(token: any(named: 'token')))
          .thenAnswer((_) async => [sampleItem]);

      final items = await repository.getItems();

      expect(items.length, 1);
      expect(items.first.title, 'Mocked Item');
      verify(() => mockStorageService.getToken()).called(1);
      verify(() => mockApiProvider.getItems(token: 'mock-token')).called(1);
    });

    test('createItem forwards item and token to provider', () async {
      when(() => mockStorageService.getToken()).thenAnswer((_) async => 'mock-token');
      when(() => mockApiProvider.createItem(any(), token: any(named: 'token')))
          .thenAnswer((_) async => sampleItem);

      final created = await repository.createItem(sampleItem);

      expect(created.id, '10');
      verify(() => mockApiProvider.createItem(sampleItem, token: 'mock-token')).called(1);
    });

    test('deleteItem delegates deletion to provider', () async {
      when(() => mockStorageService.getToken()).thenAnswer((_) async => 'mock-token');
      when(() => mockApiProvider.deleteItem('10', token: any(named: 'token')))
          .thenAnswer((_) async => true);

      final result = await repository.deleteItem('10');

      expect(result, isTrue);
      verify(() => mockApiProvider.deleteItem('10', token: 'mock-token')).called(1);
    });

    test('propagates ApiException when provider fails', () async {
      when(() => mockStorageService.getToken()).thenAnswer((_) async => 'mock-token');
      when(() => mockApiProvider.getItems(token: any(named: 'token')))
          .thenThrow(ApiException('Network Error [500]', 500));

      expect(() => repository.getItems(), throwsA(isA<ApiException>()));
    });
  });
}
