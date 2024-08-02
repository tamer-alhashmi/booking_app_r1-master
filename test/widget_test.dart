import 'package:booking_app_r1/features/app/splash_screen/splash_screen.dart';
import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/model/category/hotel_categories.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:booking_app_r1/services/app/booking_app.dart';

class MockAuthService extends Mock implements AuthService {}

class MockCategory extends Mock implements Category {}

class MockHotel extends Mock implements Hotel {}

void main() {
  testWidgets('BookingApp widget test', (WidgetTester tester) async {
    // Mock dependencies
    final MockAuthService authService = MockAuthService();
    final MockHotel hotel = MockHotel();
    final List<MockCategory> mockCategories = List.generate(3, (_) => MockCategory());

    // Define dummy latitude and longitude values
    final double latitude = 0.0;
    final double longitude = 0.0;

    // Build the BookingApp widget with mocked dependencies
    await tester.pumpWidget(
      MaterialApp(
        home: BookingApp(
          authService: authService,
          categories: mockCategories,
          hotel: hotel,
          userDetails: {},
          currentPageIndex: 0,
          onPageChanged: (int index) {},
          latitude: latitude,
          longitude: longitude,
          userId: '',
        ),
      ),
    );

    // Verify the presence of certain UI components
    expect(find.byType(SplashScreen), findsOneWidget); // Verify SplashScreen is present
    // Add more assertions as needed

    // Interact with the widget and trigger a frame
    // For example, if you have an IconButton with icon: Icons.add, you can simulate a tap on it like this:
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump(); // Trigger a frame after the tap

    // Verify the changes in the widget after interaction
    // For example, if tapping the IconButton increments a counter displayed in the UI:
    // expect(find.text('1'), findsOneWidget);
    // Add more assertions as needed
  });
}
