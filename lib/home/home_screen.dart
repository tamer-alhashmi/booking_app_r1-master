// import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_provider.dart'
//     as MyAppAuthProvider;
// import 'package:booking_app_r1/features/user_auth/presentation/pages/user/bookings_screen.dart';
// import 'package:booking_app_r1/features/user_auth/presentation/pages/user/favorite_screen.dart';
// import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_details.dart';
// import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_profile_setting/profile_setting_screen.dart';
// import 'package:booking_app_r1/home/hotel_city_group_widget.dart';
// import 'package:booking_app_r1/model/category/category.dart';
// import 'package:booking_app_r1/model/hotel/detail/hotel_details.dart';
// // import 'package:booking_app_r1/model/hotel/widgets/bottom_bar/bottom_navigate_bar.dart';
// import 'package:booking_app_r1/model/hotel/widgets/home/contact_hotel_widget.dart';
// import 'package:booking_app_r1/services/hotel_provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:booking_app_r1/services/hotel_service.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
// import 'package:booking_app_r1/model/hotel.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../model/hotel/detail/policies.dart';
// import '../model/hotel/widgets/bottom_bar/bottom_navigate_bar.dart';
// import 'hotel_card.dart';
//
// class HomeScreen extends StatefulWidget {
//   final AuthService authService;
//   bool userHasNotification = false;
//   final Hotel hotel;
//   final Map<String, dynamic> userDetails;
//   final double latitude;
//   final double longitude;
//   final String userId;
//   final HotelPolicies policies;
//   final List<Category> categories;
//
//   HomeScreen({
//     Key? key,
//     required this.hotel,
//     required this.userDetails,
//     required this.latitude,
//     required this.longitude,
//     required this.userId,
//     required this.authService,
//     required this.policies,
//     required this.categories,
//   }) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   bool hasNotification = false;
//   late List<Hotel> hotels = [];
//   final TextEditingController _cityController = TextEditingController();
//   late final ScrollController _scrollController = ScrollController();
//   Set<Marker> markers = {};
//   late String _firstName = '';
//   late String _lastName = '';
//   late UserDetails _userDetails;
//   late String _userId = '';
//   late String _profilePhotoUrl = '';
//
//   // final FirebaseAuth _auth = FirebaseAuth.instance;
//   // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // List of pages
//   late final List<Widget> _pages;
//
//   @override
//   void initState() {
//     super.initState();
//     if (_userDetails['profilePhotoUrl'] != null) {
//       precacheImage(NetworkImage(_userDetails['profilePhotoUrl'] as String), context);
//     }
//     // Initialize the pages here
//     _pages = [
//       HomeScreen(
//         hotel: widget.hotel,
//         userDetails: widget.userDetails,
//         latitude: widget.latitude,
//         longitude: widget.longitude,
//         userId: widget.userId,
//         authService: widget.authService,
//         policies: widget.policies,
//         categories: widget.categories,
//       ),
//       FavoriteScreen(
//         currentPageIndex: _selectedIndex,
//         onPageChanged: _onItemTapped,
//         categories: widget.categories,
//         hotel: widget.hotel,
//         userDetails: widget.userDetails,
//         authService: widget.authService,
//         latitude: widget.latitude,
//         longitude: widget.longitude,
//       ),
//       UserProfileSettingScreen(
//         currentPageIndex: _selectedIndex,
//         authService: widget.authService,
//         categories: widget.categories,
//         hotel: widget.hotel,
//         userDetails: widget.userDetails,
//         onPageChanged: _onItemTapped,
//         latitude: widget.latitude,
//         longitude: widget.longitude,
//         userId: widget.userId,
//       ),
//       BookingHistoryScreen(
//         currentPageIndex: _selectedIndex,
//         onPageChanged: _onItemTapped,
//         categories: widget.categories,
//         hotel: widget.hotel,
//         userDetails: widget.userDetails,
//         authService: widget.authService,
//         latitude: widget.latitude,
//         longitude: widget.longitude,
//       ),
//     ];
//
//     // Load user data and other initializations
//     _loadUserData();
//     fetchHotel();
//     checkNotifications();
//     fetchAndSetMarkers();
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//
//   void _loadUserData() async {
//     final authService = AuthService();
//     final userDetails = await authService.getUserDetails();
//     setState(() {
//       _userId = userDetails['userId'] ?? '';
//       _firstName = userDetails['firstname'] ?? '';
//       _lastName = userDetails['lastname'] ?? '';
//       _profilePhotoUrl = userDetails['profilePhotoUrl'] ?? '';
//       hasNotification = userDetails['hasNotification'] ?? false;
//     });
//   }
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   // _initializeUserDetails();
//   //   fetchHotel();
//   //   _loadUserData();
//   //   checkNotifications();
//   //   fetchAndSetMarkers();
//   // }
//
//   // Future<void> _initializeUserDetails() async {
//   //   try {
//   //     // Replace 'your_user_id' with the actual user ID
//   //     _userDetails = await UserDetails.loadUserData('your_user_id');
//   //     setState(() {}); // Trigger a rebuild to update the UI
//   //   } catch (e) {
//   //     print('Error initializing user details: $e');
//   //   }
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(
//           create: (context) => MyAppAuthProvider.AuthProvider(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => HotelProvider(),
//         ),
//       ],
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         bottomNavigationBar: CustomBottomBar(
//           currentPageIndex: 0,
//           onPageChanged: (index) {},
//           hotel: widget.hotel,
//           userDetails: widget.userDetails,
//           authService: widget.authService,
//           firstName: _firstName,
//           latitude: widget.latitude,
//           longitude: widget.longitude,
//           userId: widget.userId,
//           categories: widget.categories,
//         ),
//         body: RefreshIndicator(
//           onRefresh: _refreshPage,
//           child: Stack(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const SizedBox(height: 55),
//                   _buildSearchAndFilterBar(),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       key: const PageStorageKey('user-profile-scroll'),
//
//                       controller: _scrollController,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             const SizedBox(height: 100),
//                             const Text(
//                               'Explore United Kingdom',
//                               style: TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 10),
//                             ..._buildHotelGroups(),
//                             _buildHotelList(),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               // Positioned(
//               //   bottom: 0,
//               //   left: 0,
//               //   right: 0,
//               //   child: Container(
//               //     padding: const EdgeInsets.symmetric(
//               //         vertical: 10.0, horizontal: 20.0),
//               //     decoration: const BoxDecoration(
//               //       color: Colors.white,
//               //       boxShadow: [
//               //         BoxShadow(
//               //           color: Colors.black26,
//               //           offset: Offset(0, -1),
//               //           blurRadius: 10.0,
//               //         ),
//               //       ],
//               //     ),
//               //     child: Row(
//               //       mainAxisAlignment: MainAxisAlignment.spaceAround,
//               //       children: <Widget>[
//               //         IconButton(
//               //           icon: Icon(Icons.home,
//               //               color: _selectedIndex == 0
//               //                   ? Colors.blue
//               //                   : Colors.grey),
//               //           onPressed: () => _onItemTapped(0),
//               //         ),
//               //         IconButton(
//               //           icon: Icon(Icons.favorite,
//               //               color: _selectedIndex == 1
//               //                   ? Colors.blue
//               //                   : Colors.grey),
//               //           onPressed: () => _onItemTapped(1),
//               //         ),
//               //         IconButton(
//               //           icon: Icon(Icons.person,
//               //               color: _selectedIndex == 2
//               //                   ? Colors.blue
//               //                   : Colors.grey),
//               //           onPressed: () => _onItemTapped(2),
//               //         ),
//               //         IconButton(
//               //           icon: Icon(Icons.settings,
//               //               color: _selectedIndex == 3
//               //                   ? Colors.blue
//               //                   : Colors.grey),
//               //           onPressed: () => _onItemTapped(3),
//               //         ),
//               //       ],
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//
//       ),
//     );
//   }
//
//   Widget _buildSearchAndFilterBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             spreadRadius: 1,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.filter_list),
//             onPressed: () {
//               // Handle filter icon tap
//             },
//           ),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(25),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.search),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: TextField(
//                       controller: _cityController,
//                       decoration: const InputDecoration.collapsed(
//                         hintText: 'Where to?',
//                       ),
//                       onChanged: (value) {
//                         searchHotelsByCity(value);
//                       },
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Stack(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.notifications),
//                 onPressed: () {
//                   // Handle notification icon tap
//                 },
//               ),
//               if (widget.userHasNotification)
//                 Positioned(
//                   right: 0,
//                   top: 4,
//                   child: Container(
//                     width: 8,
//                     height: 8,
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _buildHotelGroups() {
//     return groupHotelsByCity(hotels)
//         .entries
//         .map((entry) => HotelGroupWidget(
//               city: entry.key,
//               hotels: entry.value,
//               latitude: widget.latitude,
//               longitude: widget.longitude,
//               policies: widget.policies,
//             ))
//         .toList();
//   }
//
//   Widget _buildHotelList() {
//     return Consumer<HotelProvider>(
//       builder: (context, hotelProvider, child) {
//         return ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: hotels.length,
//           itemBuilder: (context, index) {
//             final hotel = hotels[index];
//             return GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => HotelDetail(
//                       hotel: hotel,
//                       latitude: widget.latitude,
//                       longitude: widget.longitude,
//                       policies: widget.policies,
//                     ),
//                   ),
//                 );
//               },
//               child: Card(
//                 color: Colors.transparent,
//                 shadowColor: Colors.transparent,
//
//                 // shape:  CircleBorder(side: BorderSide(),eccentricity: 2),
//                 margin: EdgeInsets.symmetric(vertical: 8.0),
//                 elevation: 4.0,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     AspectRatio(
//                       aspectRatio: 16 / 9,
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(12),
//                             topLeft: Radius.circular(12)),
//                         child: hotel.profilePic.isNotEmpty
//                             ? Image.asset(
//                                 hotel.profilePic,
//                                 fit: BoxFit.cover,
//                               )
//                             : Image.asset(
//                                 'assets/splash/3weby.webp',
//                                 fit: BoxFit.cover,
//                               ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '${hotel.name} Hotel',
//                             style: TextStyle(
//                               fontSize: 18.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 8.0),
//                           Text(hotel.address),
//                           Text(
//                             hotel.city,
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Text('Price for 1 night 2 adult'),
//                               Text(
//                                 '£${hotel.nightPrice} ',
//                                 style: TextStyle(
//                                   fontSize: 20.0,
//                                   fontWeight: FontWeight.w400,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     ContactHotelWidget(
//                       hotel: hotel,
//                     ),
// //***************** Contact tools
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<String?> getImageUrl(String? imagePath) async {
//     if (imagePath == null || imagePath.isEmpty) {
//       return null;
//     }
//
//     try {
//       final ref =
//           firebase_storage.FirebaseStorage.instance.ref().child(imagePath);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       print('Error retrieving image URL: $e');
//       return null;
//     }
//   }
//
//   Future<void> fetchHotel() async {
//     try {
//       final response = await AuthService.fetchHotels();
//       if (response != null) {
//         final groupedHotels = groupHotelsByCity(response);
//         printGroupedCities(groupedHotels);
//         setState(() {
//           hotels = response;
//         });
//       }
//     } catch (error) {
//       print('Error fetching hotels: $error');
//     }
//   }
//
//   void searchHotelsByCity(String city) {
//     final List<Hotel> filteredHotels = hotels.where((hotel) {
//       return hotel.city.toLowerCase().contains(city.toLowerCase());
//     }).toList();
//
//     setState(() {
//       hotels = filteredHotels;
//     });
//   }
//
//   void printGroupedCities(Map<String, List<Hotel>> groupedCities) {
//     groupedCities.forEach((city, hotels) {
//       print('City: $city');
//       for (var hotel in hotels) {
//         print('Hotel Name: ${hotel.name}');
//       }
//       print('----------------------------------');
//     });
//   }
//
//   Future<void> fetchAndSetMarkers() async {
//     try {
//       // Assuming a method to fetch hotels for marker data
//       final hotels = await AuthService.fetchHotels();
//       Set<Marker> newMarkers = {};
//       for (var hotel in hotels) {
//         newMarkers.add(
//           Marker(
//             markerId: MarkerId(hotel.id.toString()),
//             position: LatLng(widget.latitude, widget.longitude),
//             infoWindow: InfoWindow(
//               title: hotel.name,
//               snippet: hotel.address,
//             ),
//           ),
//         );
//       }
//       setState(() {
//         markers = newMarkers;
//       });
//     } catch (error) {
//       print('Error fetching markers: $error');
//     }
//   }
//
//   Map<String, List<Hotel>> groupHotelsByCity(List<Hotel> hotels) {
//     final Map<String, List<Hotel>> hotelGroups = {};
//
//     for (final hotel in hotels) {
//       if (!hotelGroups.containsKey(hotel.city)) {
//         hotelGroups[hotel.city] = [];
//       }
//       hotelGroups[hotel.city]!.add(hotel);
//     }
//
//     return hotelGroups;
//   }
//
//   // void _loadUserData() async {
//   //   _userDetails = await UserDetails.loadUserData(widget.userId);
//   //   setState(() {
//   //     _firstName = _userDetails.firstName;
//   //     _lastName = _userDetails.lastName;
//   //     hasNotification = _userDetails.hasNotification;
//   //   });
//   // }
//
//   // Future<void> _loadUserData() async {
//   //   Map<String, dynamic> userDetails =
//   //   await widget.authService.getUserDetails(_firstName);
//   //   setState(() {
//   //     _firstName = userDetails['firstname'] ?? ''; // Assign the firstname from userDetails map
//   //   });
//   // }
//
//   Future<void> _refreshPage() async {
//     await fetchHotel();
//     checkNotifications();
//   }
//
//   Future<void> checkNotifications() async {
//     // Update state based on userDetails
//     setState(() {
//       hasNotification = _userDetails.hasNotification;
//     });
//   }
// }

import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_provider.dart'
    as MyAppAuthProvider;
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/bookings_screen.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/favorite_screen.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_details.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_profile_setting/profile_setting_screen.dart';
import 'package:booking_app_r1/home/hotel_city_group_widget.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel/detail/hotel_details.dart';
import 'package:booking_app_r1/model/hotel/widgets/home/contact_hotel_widget.dart';
import 'package:booking_app_r1/services/hotel_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:booking_app_r1/services/hotel_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/hotel/detail/policies.dart';
import '../model/hotel/widgets/bottom_bar/bottom_navigate_bar.dart';
import 'hotel_card.dart';

class HomeScreen extends StatefulWidget {
  final AuthService authService;
  final bool userHasNotification;
  final Hotel hotel;
  final Map<String, dynamic> userDetails;
  final double latitude;
  final double longitude;
  final String userId;
  final HotelPolicies policies;
  final List<Category> categories;

  HomeScreen({
    Key? key,
    required this.hotel,
    required this.userDetails,
    required this.latitude,
    required this.longitude,
    required this.userId,
    required this.authService,
    required this.policies,
    required this.categories,
    this.userHasNotification = false,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late bool hasNotification;
  late List<Hotel> hotels = [];
  final TextEditingController _cityController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Set<Marker> markers = {};
  late String _firstName = '';
  late String _lastName;
  late String _profilePhotoUrl;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(
        hotel: widget.hotel,
        userDetails: widget.userDetails,
        latitude: widget.latitude,
        longitude: widget.longitude,
        userId: widget.userId,
        authService: widget.authService,
        policies: widget.policies,
        categories: widget.categories,
      ),
      FavoriteScreen(
        currentPageIndex: _selectedIndex,
        onPageChanged: _onItemTapped,
        categories: widget.categories,
        hotel: widget.hotel,
        userDetails: widget.userDetails,
        authService: widget.authService,
        latitude: widget.latitude,
        longitude: widget.longitude,
      ),
      UserProfileSettingScreen(
        currentPageIndex: _selectedIndex,
        authService: widget.authService,
        categories: widget.categories,
        hotel: widget.hotel,
        userDetails: widget.userDetails,
        onPageChanged: _onItemTapped,
        latitude: widget.latitude,
        longitude: widget.longitude,
        userId: widget.userId,
      ),
      BookingHistoryScreen(
        currentPageIndex: _selectedIndex,
        onPageChanged: _onItemTapped,
        categories: widget.categories,
        hotel: widget.hotel,
        userDetails: widget.userDetails,
        authService: widget.authService,
        latitude: widget.latitude,
        longitude: widget.longitude,
      ),
    ];

    _loadUserData();
    fetchHotel();
    checkNotifications();
    fetchAndSetMarkers();

    if (widget.userDetails['profilePhotoUrl'] != null) {
      precacheImage(
        NetworkImage(widget.userDetails['profilePhotoUrl'] as String),
        context,
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadUserData() async {
    final authService = AuthService();
    final userDetails = await authService.getUserDetails();
    setState(() {
      _firstName = userDetails['firstname'] ?? '';
      _lastName = userDetails['lastname'] ?? '';
      _profilePhotoUrl = userDetails['profilePhotoUrl'] ?? '';
      hasNotification = userDetails['hasNotification'] ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MyAppAuthProvider.AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HotelProvider(),
        ),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,

        backgroundColor: Colors.white,
        bottomNavigationBar: CustomBottomBar(
          currentPageIndex: _selectedIndex,
          onPageChanged: _onItemTapped,
          hotel: widget.hotel,
          userDetails: widget.userDetails,
          authService: widget.authService,
          firstName: _firstName,
          latitude: widget.latitude,
          longitude: widget.longitude,
          userId: widget.userId,
          categories: widget.categories,
        ),
        body: RefreshIndicator(
          onRefresh: _refreshPage,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 55),
              _buildSearchAndFilterBar(),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 100),
                        const Text(
                          'Explore United Kingdom',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ..._buildHotelGroups(),
                        _buildHotelList(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter icon tap
            },
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _cityController,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Where to?',
                      ),
                      onChanged: (value) {
                        searchHotelsByCity(value);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  // Handle notification icon tap
                },
              ),
              if (widget.userHasNotification)
                Positioned(
                  right: 0,
                  top: 4,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildHotelGroups() {
    return groupHotelsByCity(hotels)
        .entries
        .map((entry) => HotelGroupWidget(
              city: entry.key,
              hotels: entry.value,
              latitude: widget.latitude,
              longitude: widget.longitude,
              policies: widget.policies,
            ))
        .toList();
  }

  Widget _buildHotelList() {
    return Consumer<HotelProvider>(
      builder: (context, hotelProvider, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: hotels.length,
          itemBuilder: (context, index) {
            final hotel = hotels[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotelDetail(
                      hotel: hotel,
                      policies: widget.policies,
                      userDetails: widget.userDetails,
                      userId: widget.userId,
                      latitude: widget.latitude,
                      longitude: widget.longitude,
                    ),
                  ),
                );
              },
              child: HotelCard(
                hotel: hotel,
                policies: widget.policies,
                userDetails: widget.userDetails,
                userId: widget.userId,
                latitude: widget.latitude,
                longitude: widget.longitude,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> fetchHotel() async {
    try {
      final response = await AuthService.fetchHotels();
      if (response != null) {
        final groupedHotels = groupHotelsByCity(response);
        printGroupedCities(groupedHotels);
        setState(() {
          hotels = response;
        });
      }
    } catch (error) {
      print('Error fetching hotels: $error');
    }
  }

  void printGroupedCities(Map<String, List<Hotel>> groupedCities) {
    groupedCities.forEach((city, hotels) {
      print('City: $city');
      for (var hotel in hotels) {
        print('Hotel Name: ${hotel.name}');
      }
      print('----------------------------------');
    });
  }

  Future<void> _refreshPage() async {
    await fetchHotel();
  }

  void searchHotelsByCity(String city) {
    final List<Hotel> filteredHotels = hotels.where((hotel) {
      return hotel.city.toLowerCase().contains(city.toLowerCase());
    }).toList();

    setState(() {
      hotels = filteredHotels;
    });
  }

  Future<void> checkNotifications() async {
    final userDetails = await widget.authService.getUserDetails();
    setState(() {
      hasNotification = userDetails['hasNotification'] ?? false;
    });
  }

  Map<String, List<Hotel>> groupHotelsByCity(List<Hotel> hotels) {
    Map<String, List<Hotel>> groupedHotels = {};

    for (var hotel in hotels) {
      final city = hotel.city ?? 'Unknown City';
      if (groupedHotels.containsKey(city)) {
        groupedHotels[city]!.add(hotel);
      } else {
        groupedHotels[city] = [hotel];
      }
    }

    return groupedHotels;
  }

  Future<void> fetchAndSetMarkers() async {
    final userLocation = LatLng(widget.latitude, widget.longitude);

    for (var hotel in hotels) {
      final marker = Marker(
        markerId: MarkerId(hotel.id),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: hotel.name,
          snippet: hotel.address,
        ),
      );

      setState(() {
        markers.add(marker);
      });
    }

    final userMarker = Marker(
      markerId: const MarkerId('user_location'),
      position: userLocation,
      infoWindow: const InfoWindow(
        title: 'You are here',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    setState(() {
      markers.add(userMarker);
    });
  }
}
