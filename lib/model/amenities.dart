import 'package:booking_app_r1/model/hotel/detail/navigate_tab_bar/hotels_full_description.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'hotel.dart';
// import 'hotel_categories.dart';

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

  const HotelAmenitiesCard({
    Key? key,
    required this.amenities,
    required this.hotel,
    this.height = 200.0,
    required this.latitude,
    required this.longitude, // Default height
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
                        color: Colors.green, // Customize icon color
                      ),
                      const SizedBox(
                          width: 4), // Add space between icon and text
                      Text(
                        amenity,
                        style: const TextStyle(
                          fontSize: 12, // Customize text size
                        ),
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
                    builder: (context) => HotelsFullDescription(
                      hotel: hotel,
                      initialTabIndex: 1,
                      latitude: latitude,
                      longitude: longitude, // Index of the Facilities tab
                    ),
                  ),
                );
              },
              child: const Text(
                'More Facilities',
                style: TextStyle(
                  color: Colors.blue, // Customize color of "Read more" text
                  decoration:
                      TextDecoration.none, // Add underline to "Read more" text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
