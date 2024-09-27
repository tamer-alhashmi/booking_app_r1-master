import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_details.dart';
import 'package:booking_app_r1/model/category/categories_card.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel/detail/date_selection_widget.dart';
import 'package:booking_app_r1/model/hotel/detail/policies.dart';
import 'package:booking_app_r1/model/hotel/detail/user_rooms_adoult_child_selected.dart';
import 'package:booking_app_r1/model/hotel/widgets/hotel_reviews_card_widget.dart';
import 'package:booking_app_r1/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/full_screen_image_page.dart';
import 'package:booking_app_r1/model/hotel/widgets/icons_widget/reviews_box.dart';
import 'package:booking_app_r1/model/hotel/widgets/policy_widget.dart';
import 'package:booking_app_r1/model/hotel/widgets/description.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import '../../amenities.dart';
import '../reviews.dart';
import 'navigate_tab_bar/navigation-tabs.dart';
// import 'package:carousel_slider/carousel_controller.dart' as carouselSlider;
// import 'package:flutter/src/material/carousel.dart' as materialCarousel;

class HotelDetail extends StatefulWidget {
  final Hotel hotel;
  final double latitude;
  final double longitude;
  final HotelPolicies policies;
  final String hotelId;
  // late String categoryId;

  const HotelDetail({
    Key? key,
    required this.hotel,
    required this.latitude,
    required this.longitude,
    required this.policies,
    required String userId,
    required Map<String, dynamic> userDetails,
    required this.hotelId,
    // required this.categoryId,
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
  late String categoryId;

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
        reviews = querySnapshot.docs
            .map((doc) => Review(
                  userId: doc['userId'],
                  rating: doc['rating'],
                  comment: doc['comment'],
                  timestamp: doc['timestamp'].toDate(),
                ))
            .toList();
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
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
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
      // extendBodyBehindAppBar: false,
      body: Stack(children: [
        SingleChildScrollView(
          key: const PageStorageKey('user-profile-scroll'),
          controller: scrollController,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    // Replacing CarouselSlider with PageView
                    SizedBox(
                      height: 250,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.hotel.sliderpics.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final imagePath =
                              'assets/images/${widget.hotel.id}/sliderpics/${widget.hotel.sliderpics[index]}';
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImagePage(
                                    sliderpics: widget.hotel.sliderpics
                                        .map((imageName) =>
                                            'assets/images/${widget.hotel.id}/sliderpics/$imageName')
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
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_currentPage + 1} / ${widget.hotel.sliderpics.length}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

                // HotelReviewsCardWidget(hotelId: widget.hotel.id, ), // Added line
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                                Icons.hotel,
                                color: AppTheme.accentColor),
                          ),


                          Text(
                            widget.hotel.name,
                            style: GoogleFonts.almarai(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
                              builder: (context) => NavigationTabs(
                                hotel: widget.hotel,
                                latitude: widget.latitude,
                                longitude: widget.longitude,
                                initialTabIndex: 0,
                                hotelId: widget.hotelId, nearbyCategoryId: '',
                                // categoryId: widget.categoryId,
                              ),
                            ),
                          );
                        },
                        child: DescriptionWidget(
                          description: widget.hotel.description,
                          hotel: widget.hotel,
                          latitude: widget.latitude,
                          longitude: widget.longitude,
                          hotelId: widget.hotelId,

                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NavigationTabs(
                                hotel: widget.hotel,
                                latitude: widget.latitude,
                                longitude: widget.longitude,
                                initialTabIndex: 1,
                                hotelId: widget.hotelId, nearbyCategoryId: '',
                                // categoryId: widget.categoryId,
                              ),
                            ),
                          );
                        },
                        child: HotelAmenitiesCard(
                          title: 'Most Popular Facilities',
                          amenities: widget.hotel.facilities,
                          hotel: widget.hotel,
                          latitude: widget.latitude,
                          longitude: widget.longitude,
                          hotelId: widget.hotelId,
                        ),
                      ), // Most Popular Facilities

                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NavigationTabs(
                                  hotel: widget.hotel,
                                  latitude: widget.latitude,
                                  longitude: widget.longitude,
                                  initialTabIndex: 2,
                                  hotelId: widget.hotelId, nearbyCategoryId: '',
                                // categoryId: widget.categoryId,),
                            ),
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: HotelPoliciesCardWidget(
                            hotel: widget.hotel,
                            policies: widget.hotel.policies,
                            latitude: widget.hotel.lat,
                            longitude: widget.hotel.lng,
                            hotelId: widget.hotelId,
                          ),
                        ),
                      ), // HotelPoliciesCardWidget

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NavigationTabs(
                                  hotel: widget.hotel,
                                  latitude: widget.latitude,
                                  longitude: widget.longitude,
                                  initialTabIndex: 4,
                                  hotelId: widget.hotelId, nearbyCategoryId: '',
                                // categoryId: widget.categoryId,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: double.infinity, // Extend to full width
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              // color: Colors.blue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'View Nearby Places',
                              style: AppTheme.sectionTitleTextStyle,
                            ),
                          ),
                        ),
                      ), // View Nearby Places

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NavigationTabs(
                                  hotel: widget.hotel,
                                  latitude: widget.latitude,
                                  longitude: widget.longitude,
                                  initialTabIndex: 5,
                                  hotelId: widget.hotelId, nearbyCategoryId: '',
                                // categoryId: widget.categoryId,
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
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.hasData &&
                                snapshot.data!.docs.isNotEmpty) {
                              List<Review> reviews =
                                  snapshot.data!.docs.map((doc) {
                                return Review(
                                  userId: doc['userId'],
                                  rating: (doc['rating'] as num).toDouble(),
                                  comment: doc['comment'],
                                  timestamp:
                                      (doc['timestamp'] as Timestamp).toDate(),
                                );
                              }).toList();

                              double averageRating = reviews
                                      .map((r) => r.rating)
                                      .reduce((a, b) => a + b) /
                                  reviews.length;

                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      averageRating.toStringAsFixed(2),
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Guest favorite',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'This hotel is in the top 10% based on ratings, reviews, and reliability.',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      height: 150,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: reviews.length,
                                        itemBuilder: (context, index) {
                                          final review = reviews[index];

                                          return FutureBuilder<UserDetails>(
                                            future: UserDetails.loadUserData(
                                                review.userId),
                                            builder: (context, userSnapshot) {
                                              if (userSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }

                                              if (userSnapshot.hasError) {
                                                return Text(
                                                    'Error: ${userSnapshot.error}');
                                              }

                                              if (userSnapshot.hasData) {
                                                final userDetails =
                                                    userSnapshot.data;
                                                review.userDetails =
                                                    userDetails; // Assigning nullable value

                                                return Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  width: 300,
                                                  child: Card(
                                                    elevation: 2,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              if (userDetails
                                                                      ?.profilePhotoUrl
                                                                      .isNotEmpty ??
                                                                  false)
                                                                CircleAvatar(
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          userDetails!
                                                                              .profilePhotoUrl),
                                                                ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber),
                                                              const SizedBox(
                                                                  width: 4),
                                                              Text(
                                                                  '${review.rating}'),
                                                              const Spacer(),
                                                              Text(
                                                                '${review.timestamp.toLocal()}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Expanded(
                                                            child: Text(
                                                              review.comment,
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                            'Show more',
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }

                                              return const Text(
                                                  'No user data available');
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Action to navigate to the full review page
                                      },
                                      child: Text(
                                          'Show all ${reviews.length} reviews'),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return const Text('No reviews available');
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
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoriesScreen(
                    hotelId: widget.hotel.id,
                    hotel: widget.hotel,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              textStyle: const TextStyle(fontSize: 18),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Select Room'),
          ),
        ),
      ]),
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




