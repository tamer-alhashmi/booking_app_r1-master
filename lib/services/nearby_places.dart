import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Place {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;

  Place({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory Place.fromJson(Map<String, dynamic> json, String id) {
    return Place(
      id: id,
      name: json['name'] ?? 'Unknown',
      address: json['address'] ?? 'No address available',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
  };
}



class NearbyPlaces {
  List<Place> places;

  NearbyPlaces({required this.places});

  factory NearbyPlaces.fromJson(Map<String, dynamic> json) {
    return NearbyPlaces(
      places: (json['places'] as List)
          .map((place) => Place.fromJson(place as Map<String, dynamic>, place['id']))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'places': places.map((place) => place.toJson()).toList(),
    };
  }

  static Future<NearbyPlaces?> fetchNearbyPlacesFromFirestore(String hotelId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .collection('nearby_places')
          .get();

      final placesList = querySnapshot.docs.map((doc) {
        return Place.fromJson(doc.data() as Map<String, dynamic>, doc.id); // Pass doc.id as id
      }).toList();

      return NearbyPlaces(places: placesList);
    } catch (e) {
      print('Error getting nearby places from Firestore: $e');
    }
    return null;
  }
}






// Widget displaying a list of nearby places
class NearbyPlacesWidget extends StatelessWidget {
  final NearbyPlaces nearbyPlaces;
  final Hotel hotel;
  final List<Place> places;

  const NearbyPlacesWidget({
    Key? key,
    required this.nearbyPlaces,
    required this.hotel,
    required this.places,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: nearbyPlaces.places.length,
      itemBuilder: (context, index) {
        final place = nearbyPlaces.places[index];
        return ListTile(
          title: Text(place.name),
          subtitle: Text(place.address),
          onTap: () {
            // Handle tap event if needed
          },
        );
      },
    );
  }
}

// Widget displaying nearby places in a card format
class NearbyPlacesCard extends StatelessWidget {
  final NearbyPlaces nearbyPlaces;

  const NearbyPlacesCard({required this.nearbyPlaces});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: nearbyPlaces.places.map((place) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                '${place.name}: ${place.address}',
                style: const TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Widget displaying nearby places in a grid format
class NearbyPlacesDetailsWidget extends StatelessWidget {
  final NearbyPlaces nearbyPlaces;

  const NearbyPlacesDetailsWidget({required this.nearbyPlaces});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nearby Places',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: nearbyPlaces.places.length,
          itemBuilder: (context, index) {
            final place = nearbyPlaces.places[index];
            return Card(
              elevation: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    place.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    place.address,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// Screen for displaying nearby places using `FutureBuilder`
class NearbyPlacesScreen extends StatefulWidget {
  final String hotelId;
  final Hotel hotel;

  const NearbyPlacesScreen({
    Key? key,
    required this.hotelId,
    required this.hotel,
  }) : super(key: key);

  @override
  _NearbyPlacesScreenState createState() => _NearbyPlacesScreenState();
}

class _NearbyPlacesScreenState extends State<NearbyPlacesScreen> {
  Future<NearbyPlaces?> fetchNearbyPlaces() async {
    return await NearbyPlaces.fetchNearbyPlacesFromFirestore(widget.hotelId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<NearbyPlaces?>(
        future: fetchNearbyPlaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final nearbyPlaces = snapshot.data!;
            return NearbyPlacesWidget(
              nearbyPlaces: nearbyPlaces,
              hotel: widget.hotel,
              places: nearbyPlaces.places,
            );
          } else {
            return const Center(child: Text('No nearby places found.'));
          }
        },
      ),
    );
  }
}



