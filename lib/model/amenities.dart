import 'package:booking_app_r1/model/hotel/detail/navigate_tab_bar/navigation-tabs.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'hotel.dart';
// import 'category.dart';

class HotelAmenities extends StatelessWidget {
  final List<String> amenities;
  final Hotel hotel;

  const HotelAmenities(
      {super.key, required this.amenities, required this.hotel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Most Popular Facilities:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Wrap(
              direction: Axis.horizontal,
              children: hotel.facilities.map((amenity) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Chip(
                    label: Text(amenity),
                    labelStyle: const TextStyle(
                      fontSize: 14, // Customize text size
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Customize border radius
                      side: const BorderSide(
                        color: AppTheme.primaryColor, // Customize border color
                        width: 0.5, // Customize border width
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class HotelAmenitiesCard extends StatelessWidget {
  final List<String> amenities;
  final Hotel hotel;
  final double height;
  final double latitude;
  final double longitude;
  final String hotelId;
  const HotelAmenitiesCard({
    Key? key,
    required this.amenities,
    required this.hotel,
    this.height = 200.0,
    required this.latitude,
    required this.longitude, required String title, required this.hotelId, // Default height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Most Popular Facilities:',
              style: AppTheme.headlineTextStyle,
            ),
            Wrap(
              direction: Axis.horizontal,
              children: hotel.facilities.take(5).map((amenity) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle, // You can use any icon you want
                        color: AppTheme.accentColor, // Customize icon color
                      ),
                      const SizedBox(
                          width: 4), // Add space between icon and text
                      Text(
                        amenity,
                        style:AppTheme.bodyTextStyle,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationTabs(
                      hotel: hotel,
                      initialTabIndex: 1,
                      latitude: latitude,
                      longitude: longitude, hotelId: hotelId, nearbyCategoryId: '',
                      // categoryId: '', // Index of the Facilities tab
                    ),
                  ),
                );
              },
              child: const Text(
                'More Facilities',
                style: AppTheme.linkTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
