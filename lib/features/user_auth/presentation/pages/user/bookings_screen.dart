import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
// import 'package:booking_app_r1/model/hotel/widgets/bottom_bar/bottom_navigate_bar.dart';
import 'package:flutter/material.dart';
import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';

import '../../../../../model/hotel/widgets/bottom_bar/bottom_navigate_bar.dart';


class BookingHistoryScreen extends StatefulWidget {
  final AuthService authService;
  final Category category;

  final Hotel hotel;
  final int currentPageIndex;
  final Function(int) onPageChanged;
  final Map<String, dynamic> userDetails;
  final double latitude;
  final double longitude;

  const BookingHistoryScreen({
    Key? key,
    required this.currentPageIndex,
    required this.onPageChanged,
    required this.category,
    required this.hotel,
    required this.userDetails,
    required this.authService,
    required this.latitude,
    required this.longitude,
  }) :
        super(key: key);

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  late String _firstName = '';
  late String _lastName = '';
  Map<String, dynamic> _userDetails = {}; // Initialize with empty map, updated later with user details
  int currentPageIndex = 2;
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  Future<void> _loadUserData() async {
    Map<String, dynamic> userDetails =
    (await widget.authService.getUserDetails()) as Map<String, dynamic>;
    setState(() {
      _userDetails = userDetails;
      _firstName = userDetails['firstname'] ?? ''; // Assign the firstname from userDetails map
      _lastName = userDetails['lastname'] ?? ''; // Assign the lastname from userDetails map
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Screen'),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentPageIndex: currentPageIndex,
        onPageChanged: widget.onPageChanged, // Use the onPageChanged directly
        category: widget.category,
        hotel: widget.hotel,
        userDetails: widget.userDetails,
        authService: widget.authService,
        firstName: _firstName,
        longitude: widget.longitude,
        latitude: widget.latitude, userId: '',
      ),
      body: const Center(
        child: Text('Bookings Screen Content'),
      ),
    );
  }
}
