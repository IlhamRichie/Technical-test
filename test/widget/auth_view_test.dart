import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techtest/app/data/models/user_model.dart';
import 'package:techtest/app/data/repositories/auth_repository.dart';
import 'package:techtest/app/modules/auth/controllers/auth_controller.dart';
import 'package:techtest/app/modules/auth/views/auth_view.dart';
import 'package:techtest/app/routes/app_pages.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    Get.reset();
    mockAuthRepository = MockAuthRepository();
    Get.put<IAuthRepository>(mockAuthRepository);
    Get.put<AuthController>(AuthController(authRepository: mockAuthRepository));
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('AuthView renders core UI elements including Google Sign-In and Form fields',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const GetMaterialApp(
        home: AuthView(),
      ),
    );

    expect(find.text('Masuk Akun'), findsOneWidget);
    expect(find.byKey(const Key('google_signin_button')), findsOneWidget);
    expect(find.text('Sign in with Google'), findsOneWidget);
    expect(find.byKey(const Key('email_field')), findsOneWidget);
    expect(find.byKey(const Key('password_field')), findsOneWidget);
    expect(find.byKey(const Key('login_submit_button')), findsOneWidget);
  });

  testWidgets('Submitting empty form triggers validation error messages',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const GetMaterialApp(
        home: AuthView(),
      ),
    );

    await tester.ensureVisible(find.byKey(const Key('login_submit_button')));
    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('Email tidak boleh kosong'), findsOneWidget);
    expect(find.text('Password tidak boleh kosong'), findsOneWidget);

    verifyNever(() => mockAuthRepository.loginWithEmail(any(), any()));
  });

  testWidgets('Entering invalid email format displays format error',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      const GetMaterialApp(
        home: AuthView(),
      ),
    );

    await tester.enterText(find.byKey(const Key('email_field')), 'invalid-email');
    await tester.enterText(find.byKey(const Key('password_field')), '123456');

    await tester.ensureVisible(find.byKey(const Key('login_submit_button')));
    await tester.tap(find.byKey(const Key('login_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('Format email tidak valid'), findsOneWidget);
    verifyNever(() => mockAuthRepository.loginWithEmail(any(), any()));
  });

  testWidgets('Clicking Google Sign-In button calls authRepository.loginWithGoogle',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    when(() => mockAuthRepository.loginWithGoogle()).thenAnswer(
      (_) async => const UserModel(
        id: '1',
        name: 'M. Ilham Rigan Agachi',
        email: 'maachigan@gmail.com',
      ),
    );

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: Routes.AUTH,
        getPages: [
          GetPage(name: Routes.AUTH, page: () => const AuthView()),
          GetPage(name: Routes.HOME, page: () => const Scaffold(body: Text('Home Screen'))),
        ],
      ),
    );

    await tester.tap(find.byKey(const Key('google_signin_button')));
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 4));

    verify(() => mockAuthRepository.loginWithGoogle()).called(1);
    expect(find.text('Home Screen'), findsOneWidget);
  });
}
