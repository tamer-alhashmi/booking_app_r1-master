import 'package:booking_app_r1/model/hotel/detail/navigate_tab_bar/navigation-tabs.dart';
import 'package:flutter/material.dart';

import '../../hotel.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget(
      {Key? key,
      required this.hotel,
      required String description,
      required this.latitude,
      required this.longitude,
      required this.hotelId})
      : super(key: key);
  final Hotel hotel;
  final double latitude;
  final double longitude;
  final String hotelId;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8), // Adjust the spacing as needed
              Text(
                hotel.description,
                maxLines: 3, // Adjust the maximum number of lines
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NavigationTabs(
                    latitude: latitude,
                    longitude: longitude,
                    hotel: hotel,
                    initialTabIndex: 0,
                    hotelId: hotelId, nearbyCategoryId: '',
                  // categoryId: '', // Index of the Facilities tab
                    ),
              ),
            );
          },
          child: const Text(
            'Read more',
            style: TextStyle(
              color: Colors.blue, // Customize color of "Read more" text
            ),
          ),
        ),
      ],
    );
  }
}
