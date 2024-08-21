import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_provider.dart'
    as MyAppAuthProvider;
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/bookings_screen.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/favorite_screen.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_profile_setting/profile_setting_screen.dart';
import 'package:booking_app_r1/home/hotel_city_group_widget.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel/detail/hotel_details.dart';
import 'package:booking_app_r1/services/hotel_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/model/hotel.dart';
import '../model/hotel/detail/policies.dart';
import '../model/hotel/widgets/bottom_bar/bottom_navigate_bar.dart';
import '../theme/app_theme.dart';
import 'hotel_card.dart';

class HomeScreen extends StatefulWidget {
  final AuthService authService;
  final Hotel hotel;
  final Map<String, dynamic> userDetails;
  final String userId;
  final bool userHasNotification;
  final double longitude;
  final double latitude;
  final HotelPolicies policies;
  final Category category;
  final String hotelId;
  // final String categoryId;

  HomeScreen({
    Key? key,
    required this.hotel,
    required this.userDetails,
    required this.latitude,
    required this.longitude,
    required this.userId,
    required this.authService,
    required this.policies,
    required this.category,
    this.userHasNotification = false,
    required this.hotelId,
    // required this.categoryId, // Keep it here for HomeScreen use
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
  late final String hotelId;

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
        category: widget.category,
        hotelId: widget.hotelId,
        // categoryId: widget.categoryId,
      ),
      FavoriteScreen(
        currentPageIndex: _selectedIndex,
        onPageChanged: _onItemTapped,
        category: widget.category,
        hotel: widget.hotel,
        userDetails: widget.userDetails,
        authService: widget.authService,
        latitude: widget.latitude,
        longitude: widget.longitude,
      ),
      UserProfileSettingScreen(
        currentPageIndex: _selectedIndex,
        authService: widget.authService,
        category: widget.category,
        hotel: widget.hotel,
        userDetails: widget.userDetails,
        onPageChanged: _onItemTapped,
        latitude: widget.latitude,
        longitude: widget.longitude,
        userId: widget.userId,
        hotelId: widget.hotelId,
        // categoryId: widget.categoryId,
      ),
      BookingHistoryScreen(
        currentPageIndex: _selectedIndex,
        onPageChanged: _onItemTapped,
        category: widget.category,
        hotel: widget.hotel,
        userDetails: widget.userDetails,
        authService: widget.authService,
        latitude: widget.latitude,
        longitude: widget.longitude,
      ),
    ];
    hotelId = widget.hotelId;
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
    try {
      final authService = AuthService();
      final userDetails = await authService.getUserDetails();

      setState(() {
        _firstName = userDetails?.firstName ?? '';
        _lastName = userDetails?.lastName ?? '';
        _profilePhotoUrl = userDetails?.profilePhotoUrl ?? '';
        hasNotification = userDetails?.hasNotification ?? false;
      });
    } catch (e) {
      // Handle any errors that occur during the fetch
      print("Error loading user data: $e");

      // Optionally, set default values in case of error
      setState(() {
        _firstName = '';
        _lastName = '';
        _profilePhotoUrl = '';
        hasNotification = false;
      });
    }
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
          category: widget.category,
        ),
        body: RefreshIndicator(
          onRefresh: _refreshPage,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // const SizedBox(height: 55),
              _buildSearchAndFilterBar(),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 80),
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
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        // color: AppTheme.primaryOpacityColor,
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
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
              hotelId: hotelId,
              userId: widget.userId,
              // categoryId: widget.categoryId,
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
                      hotelId: hotelId,
                      // categoryId: widget.categoryId,
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
                category: widget.category,
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
    try {
      final userDetails = await widget.authService.getUserDetails();

      setState(() {
        hasNotification = userDetails?.hasNotification ?? false;
      });
    } catch (e) {
      // Handle any errors that occur during the fetch
      print("Error fetching user details: $e");
      setState(() {
        hasNotification = false;
      });
    }
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
