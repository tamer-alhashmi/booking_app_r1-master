import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_provider.dart'
    as MyAppAuthProvider;
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_details.dart';
import 'package:booking_app_r1/home/hotel_city_group_widget.dart';
import 'package:booking_app_r1/model/category/hotel_categories.dart';
import 'package:booking_app_r1/model/hotel/detail/hotel_details.dart';
import 'package:booking_app_r1/model/hotel/widgets/bottom_bar/bottom_navigate_bar.dart';
import 'package:booking_app_r1/services/hotel_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:booking_app_r1/services/hotel_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/model/hotel.dart';

import '../model/hotel/detail/policies.dart';

class HomeScreen extends StatefulWidget {
  final AuthService authService;
  bool userHasNotification = false;
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
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasNotification = false;
  late List<Hotel> hotels = [];
  final TextEditingController _cityController = TextEditingController();
  late final ScrollController _scrollController = ScrollController();
  Set<Marker> markers = {};
  late String _firstName = '';
  late UserDetails _userDetails;

  @override
  void initState() {
    super.initState();
    fetchHotel();
    _loadUserData();
    checkNotifications();
    fetchAndSetMarkers();
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
        backgroundColor: Colors.white,
        bottomNavigationBar: CustomBottomBar(
          currentPageIndex: 0,
          onPageChanged: (index) {},
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
                              fontSize: 20, fontWeight: FontWeight.bold),
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
          )
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
                      latitude: widget.latitude,
                      longitude: widget.longitude,
                      policies: widget.policies,
                    ),
                  ),
                );
              },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: hotel.profilePic.isNotEmpty
                            ? Image.asset(
                          hotel.profilePic,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          'assets/splash/3weby.webp',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotel.name,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '£${hotel.nightPrice} / night',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

            );
          },
        );
      },
    );
  }

  Future<String?> getImageUrl(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    try {
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(imagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error retrieving image URL: $e');
      return null;
    }
  }

  Future<void> fetchHotel() async {
    try {
      final response = await HotelService.fetchHotels();
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

  void searchHotelsByCity(String city) {
    final List<Hotel> filteredHotels = hotels.where((hotel) {
      return hotel.city.toLowerCase().contains(city.toLowerCase());
    }).toList();

    setState(() {
      hotels = filteredHotels;
    });
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

  Future<void> fetchAndSetMarkers() async {
    try {
      // Assuming a method to fetch hotels for marker data
      final hotels = await HotelService.fetchHotels();
      Set<Marker> newMarkers = {};
      for (var hotel in hotels) {
        newMarkers.add(
          Marker(
            markerId: MarkerId(hotel.id.toString()),
            position: LatLng(widget.latitude, widget.longitude),
            infoWindow: InfoWindow(
              title: hotel.name,
              snippet: hotel.address,
            ),
          ),
        );
      }
      setState(() {
        markers = newMarkers;
      });
    } catch (error) {
      print('Error fetching markers: $error');
    }
  }

  Map<String, List<Hotel>> groupHotelsByCity(List<Hotel> hotels) {
    final Map<String, List<Hotel>> hotelGroups = {};

    for (final hotel in hotels) {
      if (!hotelGroups.containsKey(hotel.city)) {
        hotelGroups[hotel.city] = [];
      }
      hotelGroups[hotel.city]!.add(hotel);
    }

    return hotelGroups;
  }

  void _loadUserData() async {
    _userDetails = await UserDetails.loadUserData(widget.userId);
    setState(() {
      _firstName = _userDetails.firstName;
      hasNotification = _userDetails.hasNotification;
    });
  }

  Future<void> _refreshPage() async {
    await fetchHotel();
    checkNotifications();
  }

  Future<void> checkNotifications() async {
    // Update state based on userDetails
    setState(() {
      hasNotification = _userDetails.hasNotification;
    });
  }
}
