import 'package:booking_app_r1/model/hotel/detail/date_selection_widget.dart';
import 'package:booking_app_r1/model/hotel/detail/policies.dart';
import 'package:booking_app_r1/model/hotel/detail/user_rooms_adoult_child_selected.dart';
import 'package:booking_app_r1/model/hotel/widgets/hote_reviews_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/full_screen_image_page.dart';
import 'package:booking_app_r1/model/hotel/widgets/icons_widget/reviews_box.dart';
import 'package:booking_app_r1/model/hotel/widgets/policy_widget.dart';
import 'package:booking_app_r1/model/hotel/widgets/description.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../services/hotel_service.dart';
import '../../amenities.dart';
import '../reviews.dart';
import '../widgets/description_widget.dart';
import '../widgets/icons_widget/scrollup.dart';
import '../widgets/policies_widget.dart';
import '../widgets/scrollup_button.dart';
import 'navigate_tab_bar/hotels_full_description.dart';

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
  int _currentPage = 0;
  int _nights = 0;
  int _userRoomSelected = 1;
  int _userAdultSelected = 1;
  int _userChildrenSelected = 0;
  List<Review> reviews = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    fetchReviews(widget.hotel.id);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchReviews(String hotelId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .collection('reviews')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        reviews = querySnapshot.docs.map((doc) => Review(
          userId: doc['userId'],
          rating: doc['rating'],
          comment: doc['comment'],
          timestamp: doc['timestamp'].toDate(),
        )).toList();
      }

      setState(() {});
    } catch (error) {
      print('Error fetching reviews: $error');
    }
  }

  bool isFavorite = false;
  void addToFavorites() async {
    try {
      await FirebaseFirestore.instance
          .collection('hotels')
          .doc(widget.hotel.id)
          .update({'isFavorite': true});

      setState(() {
        widget.hotel.isFavorite = true;
      });
    } catch (e) {
      print('Error adding to favorites: $e');
    }
  }

  void removeFromFavorites() async {
    try {
      await FirebaseFirestore.instance
          .collection('hotels')
          .doc(widget.hotel.id)
          .update({'isFavorite': false});

      setState(() {
        widget.hotel.isFavorite = false;
      });
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }

  void toggleFavorite() {
    if (isFavorite) {
      removeFromFavorites();
    } else {
      addToFavorites();
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Add share functionality here
            },
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CarouselSlider.builder(
                  itemCount: widget.hotel.sliderpics.length,
                  options: CarouselOptions(
                    height: 250,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                  itemBuilder: (context, index, realIdx) {
                    final imagePath = 'assets/images/${widget.hotel.name}/sliderpics/${widget.hotel.sliderpics[index]}';
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImagePage(
                              sliderpics: widget.hotel.sliderpics
                                  .map((imageName) => 'assets/images/${widget.hotel.name}/sliderpics/$imageName')
                                  .toList(),
                              initialIndex: index,
                              images: [],
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_currentPage + 1} / ${widget.hotel.sliderpics.length}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            HotelReviewsCardWidget(hotelId: widget.hotel.id, reviews: [],), // Added line
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.hotel.name,
                    style: GoogleFonts.almarai(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ReviewsBox(hotel: widget.hotel),
                  const SizedBox(height: 16),
                  Text(
                    '${widget.hotel.discount}% off',
                    style: const TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Economic Discount',
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Price for ${_nights > 0 ? '$_nights nights' : '1 night'}, 2 adults',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        _nights > 0
                            ? '${widget.hotel.nightPrice * _nights} USD'
                            : '${widget.hotel.nightPrice} USD',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Total Price',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DateSelectionWidget(
                    hotel: widget.hotel,
                    onDatesSelected: (checkInDate, checkOutDate, nights) {
                      setState(() {
                        _nights = nights;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  RoomsAndGuestsSelector(
                    onSelectionChanged: (rooms, adults, children) {
                      setState(() {
                        _userRoomSelected = rooms;
                        _userAdultSelected = adults;
                        _userChildrenSelected = children;
                      });
                    },
                    hotel: widget.hotel,
                  ),
                  const SizedBox(height: 16),
                  HotelMapLocation(
                    hotel: widget.hotel,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HotelsFullDescription(
                            hotel: widget.hotel,
                            latitude: widget.latitude,
                            longitude: widget.longitude,
                            initialTabIndex: 1,
                          ),
                        ),
                      );
                    },
                    child: HotelAmenitiesCard(
                      title: 'Most Popular Facilities',
                      amenities: widget.hotel.facilities, hotel: widget.hotel, latitude: widget.latitude, longitude: widget.longitude,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HotelsFullDescription(
                            hotel: widget.hotel,
                            latitude: widget.latitude,
                            longitude: widget.longitude,
                            initialTabIndex: 0,
                          ),
                        ),
                      );
                    },
                    child: DescriptionWidget(
                      description: widget.hotel.description,
                      hotel: widget.hotel,
                      latitude: widget.latitude,
                      longitude: widget.longitude,
                    ),
                  ),
                  const SizedBox(height: 16),
                  HotelPoliciesCardWidget(
                    hotel: widget.hotel,
                    policies: widget.hotel.policies,
                    latitude: widget.hotel.lat,
                    longitude: widget.hotel.lng,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HotelsFullDescription(
                            hotel: widget.hotel,
                            latitude: widget.latitude,
                            longitude: widget.longitude,
                            initialTabIndex: 4,
                          ),
                        ),
                      );
                    },
                    child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('hotels')
                          .doc(widget.hotel.id)
                          .collection('reviews')
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          List<Review> reviews = snapshot.data!.docs.map((doc) {
                            return Review(
                              userId: doc['userId'],
                              rating: doc['rating'],
                              comment: doc['comment'],
                              timestamp: (doc['timestamp'] as Timestamp).toDate(),
                            );
                          }).toList();

                          return HotelReviewsCardWidget(reviews: reviews, hotelId: widget.hotel.id);
                        }

                        return Text('No reviews available');
                      },
                    ),
                  ),
                ],
              ),
            ),
            // ScrollUpButton(controller: scrollController),
          ],
        ),
      ),
    );
  }
}

class HotelMapLocation extends StatelessWidget {
  final Hotel hotel;

  const HotelMapLocation({Key? key, required this.hotel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(hotel.lat, hotel.lng),
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId(hotel.id),
            position: LatLng(hotel.lat, hotel.lng),
            infoWindow: InfoWindow(
              title: hotel.name,
              snippet: '${hotel.city} - ${hotel.address}',
            ),
          ),
        },
      ),
    );
  }
}




