import 'package:booking_app_r1/model/hotel.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

class HotelMap extends StatelessWidget {
  final Set<Marker> markers;
  // final ScrollController scrollController;

  const HotelMap(
      {Key? key,
      required this.markers,
      required Hotel hotel,
      required double latitude,
      required double longitude})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LatLngBounds bounds = getBounds(markers);
    LatLng center = LatLng(
        (bounds.southwest.latitude + bounds.northeast.latitude) / 2,
        (bounds.southwest.longitude + bounds.northeast.longitude) / 2);

    return GoogleMap(
      markers: markers,
      // Assuming bounds is an instance of LatLngBounds
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: getZoomLevel(bounds),
      ),
    );
  }

  LatLngBounds getBounds(Set<Marker> markers) {
    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (Marker marker in markers) {
      double lat = marker.position.latitude;
      double lng = marker.position.longitude;

      minLat = math.min(minLat, lat);
      maxLat = math.max(maxLat, lat);
      minLng = math.min(minLng, lng);
      maxLng = math.max(maxLng, lng);
    }
// Ensure that minLat is less than or equal to maxLat
    if (minLat > maxLat) {
      double temp = minLat;
      minLat = maxLat;
      maxLat = temp;
    }

    // Ensure that minLng is less than or equal to maxLng
    if (minLng > maxLng) {
      double temp = minLng;
      minLng = maxLng;
      maxLng = temp;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  double getZoomLevel(LatLngBounds bounds) {
    const double padding = 50.0; // adjust as needed
    double maxZoom = 18.0; // maximum allowed by Google Maps

    double angle = bounds.northeast.longitude - bounds.southwest.longitude;
    double zoom = math.log(360.0 / angle) / math.ln2;

    return math.min(zoom, maxZoom);
  }
}
