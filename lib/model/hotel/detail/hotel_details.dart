import 'package:booking_app_r1/model/hotel/detail/policies.dart';
import 'package:booking_app_r1/services/all_hotels_map.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/full_screen_image_page.dart';
import 'package:booking_app_r1/model/hotel/widgets/icons_widget/reviews_box.dart';
import 'package:booking_app_r1/model/hotel/widgets/policy_widget.dart';
import 'package:booking_app_r1/model/hotel/widgets/description.dart';
import 'package:booking_app_r1/model/category/hotel_categories.dart';
import 'package:booking_app_r1/services/nearby_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../services/hotel_service.dart';
import '../widgets/description_widget.dart';
import '../widgets/policies_widget.dart';
import '../widgets/scrollup_button.dart';

class HotelDetail extends StatefulWidget {
  final Hotel hotel;
  final double latitude;
  final double longitude;
  final HotelPolicies policies;

  const HotelDetail({
    Key? key,
    required this.hotel,
    required this.latitude,
    required this.longitude,
    required this.policies,
  }) : super(key: key);

  @override
  _HotelDetailState createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  int _nights = 0;
  int _userRoomSelected = 1;
  int _userAdultSelected = 1;
  int _userChildrenSelected = 0;
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < widget.hotel.sliderpics.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final List<Category> categories =
        await CategoryService.fetchCategoriesForHotel(widget.hotel.name);
    setState(() {
      _categories = categories;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  static Future<String?> getImageUrl(String imagePath) async {
    try {
      firebase_storage.FirebaseStorage storage =
          firebase_storage.FirebaseStorage.instance;
      firebase_storage.Reference ref = storage.ref(imagePath);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error fetching image URL: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    Set<Marker> hotelMarkers = {
      Marker(
        markerId: MarkerId(widget.hotel.id),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: widget.hotel.name,
          snippet: '${widget.hotel.city} - ${widget.hotel.address}',
        ),
      ),
    };
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).appBarTheme.titleTextStyle?.color,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
            color: Theme.of(context).appBarTheme.iconTheme?.color,
          ),
        ],
        elevation: Theme.of(context).appBarTheme.elevation ?? 0,
        shape: Theme.of(context).appBarTheme.shape,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.hotel.name} Hotel',
                style: GoogleFonts.almarai(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ReviewsBox(hotel: widget.hotel),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 200.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.hotel.sliderpics.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Image.asset(
                              widget.hotel.sliderpics[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    if (widget.hotel.sliderpics.length > 6)
                      Positioned(
                        bottom: 8.0,
                        right: 8.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImagePage(
                                  sliderpics: widget.hotel.sliderpics,
                                  initialIndex: 5,
                                  images: [],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: const Text(
                              '+2 More',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),


              // Start Categories
              SizedBox(
                child:  _categories.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return ListTile(
                      title: Text(category.title),
                      subtitle: Text(category.description),
                    );
                  },
                ),
              ),


            const SizedBox(height: 16),
              Text(
                'Description',
                style: GoogleFonts.almarai(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DescriptionWidget(
                description: widget.hotel.description,
                hotel: widget.hotel,
                latitude: widget.latitude,
                longitude: widget.longitude,
              ),
              const SizedBox(height: 16),
              HotelMap(
                hotel: widget.hotel,
                latitude: widget.latitude,
                longitude: widget.longitude,
                markers: hotelMarkers,
              ),
              const SizedBox(height: 16),
              Text(
                'Hotel Policies',
                style: GoogleFonts.almarai(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              PoliciesWidget(
                policies: widget.policies, hotel: widget.hotel,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewsBox(hotel: widget.hotel),
                    ),
                  );
                },
                child: ReviewsBox(hotel: widget.hotel),
              ),
              const SizedBox(height: 16),
              FutureBuilder<NearbyPlaces?>(
                future: NearbyPlaces.fetchNearbyPlacesFromFirestore(
                    widget.hotel.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final nearbyPlaces = snapshot.data!;
                    return NearbyPlacesWidget(
                      nearbyPlaces: nearbyPlaces,
                      hotel: widget.hotel,
                      places: [],
                    );
                  } else {
                    return const Center(child: Text('No nearby places found.'));
                  }
                },
              ),
              ScrollupButton(scrollController: scrollController),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.book),
        label: const Text('Book Now'),
      ),
    );
  }
}
