import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:flutter/rendering.dart';

import '../model/hotel/detail/hotel_details.dart';
import '../model/hotel/detail/policies.dart';
import '../theme/app_theme.dart';

class HotelGroupWidget extends StatelessWidget {
  final String city;
  final List<Hotel> hotels;
  final double latitude;
  final double longitude;
  final HotelPolicies policies;
  final String hotelId;
  final String userId;
  // final String categoryId;

  const HotelGroupWidget({
    Key? key,
    required this.city,
    required this.hotels,
    required this.latitude,
    required this.longitude,
    required this.policies,
    required this.hotelId, required this.userId,
    // required this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            city,
            style: AppTheme.headlineTextStyle,
          ),
        ),
        SizedBox(
          height: 200, // Adjust the height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              final hotel = hotels[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => HotelDetail(
                        hotel: hotel,
                        latitude: latitude,
                        longitude: longitude,
                        policies: policies, userId: userId, userDetails: {}, hotelId: hotelId,
                        // categoryId: categoryId,
                      ),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0); // Slide in from the right
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween =
                        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                      // settings: RouteSettings(
                      //   arguments: {
                      //     'authService': authService,
                      //     'category': category,
                      //     'hotel': hotel,
                      //     'userDetails': userDetails,
                      //   },
                      // ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: 150, // Adjust the width as needed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0), // Adjust the radius as needed
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
                        ), //Hotel Profile image
                        //Hotel Profile image
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(
                                  Icons.hotel,
                                  color: AppTheme.accentColor),),

                            Text(
                              hotel.name,
                              style: AppTheme.cardHeadlineTextStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Icon(
                                  Icons.location_city,
                                  color: AppTheme.accentColor),
                            ),
                            Expanded(child: Text(
                              hotel.address,
                              style: AppTheme.addressTextStyle,),)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }


}
