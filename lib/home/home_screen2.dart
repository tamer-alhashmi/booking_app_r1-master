// import 'package:booking_app_r1/model/category/hotel_categories.dart';
// import 'package:booking_app_r1/model/icons.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../features/user_auth/firebase_auth_impelmentation/auth_service.dart';
// import '../model/hotel.dart';
// import '../services/hotels_apis.dart';
// import '../theme/app_theme.dart';
// import '../model/hotel_details.dart';
// import '../model/widgets/bottom_navigate_bar.dart';
//
//
// class HomeScreenModel extends StatefulWidget {
//   final AuthService authService;
//   final Categories categories;
//   final Hotel hotel;
//   const HomeScreenModel({super.key, required this.authService, required this.categories, required this.hotel});
//
//   @override
//   State<HomeScreenModel> createState() => _HomeScreenModelState();
// }
//
// class _HomeScreenModelState extends State<HomeScreenModel> {
//   late List<Hotel> hotels = [];
//   final TextEditingController _cityController = TextEditingController();
//   late ScrollController _scrollController = ScrollController();
//   Set<Marker> markers = {};
//   @override
//   void initState() {
//     super.initState();
//     fetchHotel();
//     fetchAndSetMarkers();
//   }
//
//   Future<void> fetchAndSetMarkers() async {
//     try {
//       final fetchedHotels = await HotelsApi.fetchHotel();
//       setState(() {
//         hotels = fetchedHotels;
//         markers = fetchedHotels.map((hotel) {
//           return Marker(
//             markerId: MarkerId(hotel.id.toString()),
//             position: LatLng(hotel.lat, hotel.lng),
//             infoWindow: InfoWindow(title: hotel.name, snippet: hotel.address),
//             onTap: () {
//               print('Marker tapped: ${hotel.name}');
//             },
//           );
//         }).toSet();
//       });
//     } catch (error) {
//       print('Error fetching markers: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent, // Make background transparent
//
//       bottomNavigationBar: CustomBottomBar(
//         currentPageIndex: 0,
//         onPageChanged: (index) {}, categories: widget.categories, hotel: widget.hotel,
//       ),
//
//       body: st,
//
//
//     );
//   }
// }
