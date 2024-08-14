import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/detail/policies.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HotelCard extends StatelessWidget {
  final Hotel hotel;

  HotelCard({required this.hotel, required String userId, required Map<String, dynamic> userDetails, required HotelPolicies policies, required double longitude, required double latitude});

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
                Text(
                  hotel.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(hotel.address),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                  onPressed: () {
                    // Extract the phone number from the Firestore document
                    final phoneNumber = hotel.whatsapp; // Assuming this is just the number
                    final whatsappUrl = 'https://wa.me/$phoneNumber?text=Hello%20${hotel.name}';
                    launchUrl(Uri.parse(whatsappUrl));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.email, color: Colors.blue),
                  onPressed: () {
                    final emailUrl = 'mailto:${hotel.email}';
                    launchUrl(Uri.parse(emailUrl));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.phone, color: Colors.black),
                  onPressed: () {
                    final phoneUrl = 'tel:${hotel.phone}';
                    launchUrl(Uri.parse(phoneUrl));
                  },
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
