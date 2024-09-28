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
import '../../theme/app_theme.dart';
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
                            name: widget.hotel.name,
                            reception: widget.hotel.reception,
                            discount: widget.hotel.discount,
                            description: widget.hotel.description,
                            city: widget.hotel.city,
                            address: widget.hotel.address,
                            lat: widget.hotel.lat,
                            lng: widget.hotel.lng,
                            starRate: widget.hotel.starRate,
                            nightPrice: widget.hotel.nightPrice,
                            profilePic: widget.hotel.profilePic,
                            sliderpics: widget.hotel.sliderpics,
                            facilities: widget.hotel.facilities,
                            policies: HotelPolicies(
                              checkIn: widget.hotel.policies.checkIn,
                              checkOut: widget.hotel.policies.checkOut,
                              accommodationType: widget.hotel.policies.accommodationType,
                              petPolicy: widget.hotel.policies.petPolicy,
                            ),
                            activitiesAndExperiences: widget.hotel.activitiesAndExperiences,
                            isFavorite: false,
                            termsAndConditions: widget.hotel.termsAndConditions,
                            categories: widget.hotel.categories,
                            whatsapp: widget.hotel.whatsapp,
                            email: widget.hotel.email,
                            phone: widget.hotel.phone,
                            nearbyPlace: NearbyPlaces(nearbyCategories: []),
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
                          style: AppTheme.sectionTitleTextStyle,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.catFullName,
                          style: AppTheme.sectionTitleTextStyle,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category.catHotelDescreption,
                          style: AppTheme.bodyTextStyle,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.bed, color: AppTheme.primaryColor),
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
                            const Icon(Icons.group, color: AppTheme.primaryColor),
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
                                color: AppTheme.primaryColor),
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
                          style: AppTheme.subheadTextStyle,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: category.amenities.take(6).map((amenity) {
                            return Row(
                              mainAxisSize: MainAxisSize.min, // This ensures the row only takes the needed space
                              children: [
                                const Icon(
                                  Icons.check, // Replace with any icon that matches the amenity
                                  color: AppTheme.primaryColor,
                                  size: 20.0, // Adjust the size of the icon
                                ),
                                const SizedBox(width: 4), // Add some space between icon and text
                                Text(
                                  amenity,
                                  style: const TextStyle(
                                    color: AppTheme.textColor,
                                    fontSize: 14.0, // Adjust the font size if needed
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20,)
                        ,
                        ContactToolWidget(
                          hotel: widget.hotel,
                          category: category,
                        ),
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
