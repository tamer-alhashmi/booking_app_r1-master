import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/model/category/category_detail_screen.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/detail/policies.dart';
import 'package:booking_app_r1/model/hotel/widgets/home/contact_tool_widget.dart';
import 'package:booking_app_r1/services/nearby_places.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'category.dart';

class CategoriesScreen extends StatefulWidget {
  final String hotelId;
  final Hotel hotel;

  const CategoriesScreen({Key? key, required this.hotelId, required this.hotel})
      : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late String _firstName = '';
  late String _lastName = '';
  late String _profilePhotoUrl = '';
  late bool hasNotification = false;

  Future<List<Category>> fetchCategories(String hotelId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .collection('category')
          .get();

      return querySnapshot.docs.map((doc) {
        return Category.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching category: $e');
      return [];
    }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Room'),
      ),
      body: FutureBuilder<List<Category>>(
        future: fetchCategories(widget.hotelId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          final categories = snapshot.data!;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryDetailScreen(
                          category: category,
                          hotel: Hotel(
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
                            phone: '', nearbyPlace: NearbyPlaces(nearbyCategories: []),
                          ),
                        ),
                      ));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 6.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (category.catProPicUrl.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.asset(
                              category.catProPicUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          category.catTitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.catFullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.catHotelDescreption,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.bed, color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            Text(
                              'Bed Type: ${category.bedType}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.group, color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            Text(
                              'Capacity: ${category.capacity}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.square_foot,
                                color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            Text(
                              'Room Size: ${category.roomSize}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Amenities:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: category.amenities.take(6).map((amenity) {
                            return Chip(
                              label: Text(amenity),
                              backgroundColor: Colors.blueAccent.shade100,
                              labelStyle: const TextStyle(color: Colors.white),
                            );
                          }).toList(),
                        ),
                        ContactToolWidget(
                          hotel: widget.hotel,
                          category: category,
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //     children: [
                        //       IconButton(
                        //         iconSize: 30,
                        //         icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                        //         onPressed: () {
                        //           final whatsappMessage = Uri.encodeComponent(
                        //               'Hi, I am interested in your property at ${widget.hotel.name} Hotel,\nLocated at ${widget.hotel.address}.\nName: $_firstName $_lastName.'
                        //           );
                        //           final whatsappUrl = 'https://wa.me/${widget.hotel.whatsapp}?text=$whatsappMessage';
                        //           launchUrl(Uri.parse(whatsappUrl));
                        //         },
                        //       ),
                        //       IconButton(
                        //         iconSize: 30,
                        //         icon: Icon(Icons.email, color: Colors.blue),
                        //         onPressed: () {
                        //           final emailMessage = Uri.encodeComponent(
                        //               'Hi, I am interested in your property at ${widget.hotel.name} Hotel,\nLocated at ${widget.hotel.address}.\nName: $_firstName $_lastName'
                        //           );
                        //           final emailUrl = 'mailto:${widget.hotel.email}?subject=Property Inquiry&body=$emailMessage';
                        //           launchUrl(Uri.parse(emailUrl));
                        //         },
                        //       ),
                        //       IconButton(
                        //         iconSize: 30,
                        //         icon: Icon(Icons.phone, color: Colors.black),
                        //         onPressed: () {
                        //           final phoneUrl = 'tel:${widget.hotel.phone}';
                        //           launchUrl(Uri.parse(phoneUrl));
                        //         },
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
