import 'package:booking_app_r1/model/hotel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HotelMapLocation extends StatelessWidget {
  const HotelMapLocation({Key? key, required this.hotel}) : super(key: key);

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    // Ensure coordinates are available and non-null
    LatLng hotelLatLng = LatLng(hotel.lat, hotel.lng);

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${hotel.name} Hotel location',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 280, // Specify the desired height for the map
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: hotelLatLng,
                zoom: 12.0,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('hotelMarker'),
                  position: hotelLatLng,
                  infoWindow: InfoWindow(
                    title: '${hotel.name} Hotel',
                    snippet: '${hotel.city} - ${hotel.address}',
                  ),
                ),
              },
            ),
          ),
          // Optionally, you can include the city and address text below the map
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text('${hotel.city} - ${hotel.address}'),
          ),
        ],
      ),
    );
  }
}
