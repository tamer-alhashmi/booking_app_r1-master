import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_provider.dart';
import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/detail/policies.dart';
import 'package:booking_app_r1/services/app/booking_app.dart';
import 'package:booking_app_r1/services/hotels_apis.dart';
import 'package:booking_app_r1/services/main_firebase_serv/update_firestore.dart';
import 'package:booking_app_r1/services/nearby_places.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for local storage
  await GetStorage.init();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize your AuthService and Hotel instances here
  final AuthService authService = AuthService();

  //  hotel initialization
  final Hotel hotel = Hotel(
    id: "id",
    name: 'Sample Hotel',
    reception: 'Manned',
    discount: 10,
    description: 'This is a sample hotel description',
    city: 'Sample City',
    address: 'Sample Address',
    lat: 0.0,
    lng: 0.0,
    starRate: '5',
    nightPrice: '100',
    profilePic: 'sample_profile_picture.jpg',
    sliderpics: ['image1.jpg', 'image2.jpg'],
    facilities: ['Amenity 1', 'Amenity 2'],
    policies: HotelPolicies(
      checkIn: '',
      checkOut: '',
      accommodationType: '',
      petPolicy: '',
    ),
    activitiesAndExperiences: [],
    isFavorite: false,
    termsAndConditions: '',
    categories: [],
    whatsapp: '',
    email: '',
    phone: '',
    nearbyPlace: NearbyPlaces(nearbyCategories: []),
  );

  // Define latitude and longitude for fetching nearby places
  const double latitude = 0.0;
  const double longitude = 0.0;

  // Get the hotel ID from the initialized hotel
  final String hotelId = hotel.id;
  // const String nearbyCategoryId ;



  final String categoryId;
  final Category category = Category(
    id: 'sample_id',
    catTitle: 'Sample Category',
    catFullName: 'Sample Full Name',
    catDescreption: 'Sample Description',
    bedType: 'Queen',
    capacity: 2,
    amenities: ['WiFi', 'TV'],
    galleryUrl: ['1.jpg', '2.jpg'],
    roomSize: '30 sqm',
    catProPicUrl: 'sample_tropic_url.jpg',
    catHotelDescreption: 'Full Sample Description',
  );

  runApp(MyApp(
    authService: authService,
    hotel: hotel,
    userDetails: {},
    currentPageIndex: 0, // Set your initial page index here
    onPageChanged: (int index) {    },
    latitude: latitude,
    longitude: longitude,
    userId: "", category: category, hotelId: hotelId, categoryId: '',
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final Hotel hotel;
  final int currentPageIndex;
  final Function(int) onPageChanged;
  final Map<String, dynamic> userDetails;
  final double latitude;
  final double longitude;
  final String userId;
  final Category category;
  final String hotelId;
  final String categoryId;

  const MyApp({
    Key? key,
    required this.authService,
    required this.hotel,
    required this.userDetails,
    required this.currentPageIndex,
    required this.onPageChanged,
    required this.latitude,
    required this.longitude,
    required this.userId,
    required this.category, required this.hotelId,
    required this.categoryId,
  }) : super(key: key);

  void updateCurrentPageIndex(int index) {
    onPageChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: FutureBuilder(
        // Fetch theme mode from shared preferences
        future: _getSavedThemeMode(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final ThemeMode themeMode =
                snapshot.data == true ? ThemeMode.dark : ThemeMode.light;
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Booking App',
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeMode,
              home: BookingApp(
                authService: authService,
                hotel: hotel,
                currentPageIndex: currentPageIndex,
                onPageChanged: updateCurrentPageIndex,
                userDetails: userDetails,
                latitude: latitude,
                longitude: longitude,
                userId: userId,
                category: category, hotelId: hotelId, categoryId: categoryId,
              ),
            );
          } else {
            return const CircularProgressIndicator(); // Loading indicator
          }
        },
      ),
    );
  }

  // Method to get the saved theme mode from shared preferences
  Future<bool> _getSavedThemeMode() async {
    final prefs = GetStorage();
    return prefs.read('isDarkModeEnabled') ?? false;
  }
}



// import 'package:booking_app_r1/services/main_firebase_serv/update_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   // await updateNearbyPlacesForAllHotels(); // Make sure this is awaited
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Firestore Update Script',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Firestore Update Script'),
//         ),
//         body: Center(
//           child: Text('Run the script to update Firestore'),
//         ),
//       ),
//     );
//   }
// }


