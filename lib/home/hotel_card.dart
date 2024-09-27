import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/detail/policies.dart';
import 'package:booking_app_r1/model/hotel/widgets/home/contact_tool_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;
  final Category category;


  HotelCard(
      {required this.hotel,
      required String userId,
      required Map<String, dynamic> userDetails,
      required HotelPolicies policies,
      required double longitude,
      required double latitude,
        required this.category,
         });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                ),
                Text(
                  hotel.city,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '£${hotel.nightPrice} / night',
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ContactToolWidget(hotel: hotel, category: category),
        ],
      ),
    );
  }
}
