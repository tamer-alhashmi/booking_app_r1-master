import 'dart:convert';
import 'package:booking_app_r1/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

// class Place {
//   final String placeId;
//   final String name;
//   final double rating;
//   final String type;
//   final Geometry geometry;
//
//   Place({
//     required this.placeId,
//     required this.name,
//     required this.rating,
//     required this.type,
//     required this.geometry,
//   }) {
//     print('Place created: $name (ID: $placeId)');
//   }
//
//   factory Place.fromJson(Map<String, dynamic> json) {
//     print('Parsing Place from JSON...');
//     return Place(
//       placeId: json['place_id'] as String,
//       name: json['name'] as String,
//       rating: json['rating']?.toDouble() ?? 0.0,
//       type: json['type'] as String,
//       geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     print('Converting Place to JSON...');
//     return {
//       'place_id': placeId,
//       'name': name,
//       'rating': rating,
//       'type': type,
//       'geometry': geometry.toJson(),
//     };
//   }
//
//   factory Place.fromFirestore(DocumentSnapshot doc) {
//     print('Fetching Place from Firestore...');
//     final data = doc.data() as Map<String, dynamic>;
//     return Place.fromJson(data);
//   }
// }
//
// class Geometry {
//   final Location location;
//
//   Geometry({required this.location}) {
//     print('Geometry created with location: (${location.lat}, ${location.lng})');
//   }
//
//   factory Geometry.fromJson(Map<String, dynamic> json) {
//     print('Parsing Geometry from JSON...');
//     return Geometry(
//       location: Location.fromJson(json['location']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     print('Converting Geometry to JSON...');
//     return {
//       'location': location.toJson(),
//     };
//   }
// }
//
// class Location {
//   final double lat;
//   final double lng;
//
//   Location({required this.lat, required this.lng}) {
//     print('Location created: ($lat, $lng)');
//   }
//
//   factory Location.fromJson(Map<String, dynamic> json) {
//     print('Parsing Location from JSON...');
//     return Location(
//       lat: json['lat'] as double,
//       lng: json['lng'] as double,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     print('Converting Location to JSON...');
//     return {
//       'lat': lat,
//       'lng': lng,
//     };
//   }
// }
//
// class CustomLatLng {
//   final double lat;
//   final double lng;
//
//   CustomLatLng({
//     required this.lat,
//     required this.lng,
//   }) {
//     print('CustomLatLng created: ($lat, $lng)');
//   }
//
//   factory CustomLatLng.fromJson(Map<String, dynamic> json) {
//     print('Parsing CustomLatLng from JSON...');
//     return CustomLatLng(
//       lat: json['lat'] as double,
//       lng: json['lng'] as double,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     print('Converting CustomLatLng to JSON...');
//     return {
//       'lat': lat,
//       'lng': lng,
//     };
//   }
// }
//
// class Viewport {
//   final CustomLatLng northeast;
//   final CustomLatLng southwest;
//
//   Viewport({
//     required this.northeast,
//     required this.southwest,
//   }) {
//     print('Viewport created with NE: (${northeast.lat}, ${northeast.lng}), SW: (${southwest.lat}, ${southwest.lng})');
//   }
//
//   factory Viewport.fromJson(Map<String, dynamic> json) {
//     print('Parsing Viewport from JSON...');
//     return Viewport(
//       northeast:
//       CustomLatLng.fromJson(json['northeast'] as Map<String, dynamic>),
//       southwest:
//       CustomLatLng.fromJson(json['southwest'] as Map<String, dynamic>),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     print('Converting Viewport to JSON...');
//     return {
//       'northeast': northeast.toJson(),
//       'southwest': southwest.toJson(),
//     };
//   }
// }
//
// class NearbyCategory {
//   final String categoryName;
//   final List<Place> places;
//
//   NearbyCategory({
//     required this.categoryName,
//     required this.places,
//   }) {
//     print('NearbyCategory created: $categoryName with ${places.length} places');
//   }
//
//   factory NearbyCategory.fromFirestore(QuerySnapshot querySnapshot) {
//     print('Fetching NearbyCategory from Firestore...');
//     List<Place> places = querySnapshot.docs.map((doc) {
//       return Place.fromFirestore(doc);
//     }).toList();
//
//     return NearbyCategory(
//       categoryName: querySnapshot.docs.isNotEmpty
//           ? querySnapshot.docs.first.reference.parent.parent!.id
//           : '',
//       places: places,
//     );
//   }
//
//   // Convert NearbyCategory to JSON
//   Map<String, dynamic> toJson() {
//     print('Converting NearbyCategory to JSON...');
//     return {
//       'categoryName': categoryName,
//       'places': places.map((place) => place.toJson()).toList(),
//     };
//   }
//
//   // Factory method to create NearbyCategory from JSON
//   static NearbyCategory fromJson(Map<String, dynamic> json) {
//     print('Parsing NearbyCategory from JSON...');
//     return NearbyCategory(
//       categoryName: json['categoryName'] as String,
//       places: (json['places'] as List<dynamic>)
//           .map((placeJson) => Place.fromJson(placeJson as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }
//
// class NearbyPlaces {
//   final List<NearbyCategory> nearbyCategories;
//
//   NearbyPlaces({
//     required this.nearbyCategories,
//   }) {
//     print('NearbyPlaces created with ${nearbyCategories.length} categories');
//   }
//
//   static Future<NearbyPlaces> fromFirestore(
//       DocumentSnapshot<Map<String, dynamic>> doc) async {
//     print('Fetching NearbyPlaces from Firestore...');
//     List<NearbyCategory> nearbyCategories = [];
//
//     final nearbyPlacesCollection = doc.reference.collection('nearby_places');
//     final categoriesSnapshots = await nearbyPlacesCollection.get();
//
//     for (var categorySnapshot in categoriesSnapshots.docs) {
//       final placesCollection = categorySnapshot.reference.collection('places');
//       final placesSnapshots = await placesCollection.get();
//       nearbyCategories.add(NearbyCategory.fromFirestore(placesSnapshots));
//     }
//     return NearbyPlaces(nearbyCategories: nearbyCategories);
//   }
//
//   // Convert NearbyPlaces to JSON
//   Map<String, dynamic> toJson() {
//     print('Converting NearbyPlaces to JSON...');
//     return {
//       'nearbyCategories':
//       nearbyCategories.map((category) => category.toJson()).toList(),
//     };
//   }
//
//   // Factory method to create NearbyPlaces from JSON
//   static NearbyPlaces fromJson(Map<String, dynamic> json) {
//     print('Parsing NearbyPlaces from JSON...');
//     return NearbyPlaces(
//       nearbyCategories: (json['nearbyCategories'] as List<dynamic>)
//           .map((categoryJson) =>
//           NearbyCategory.fromJson(categoryJson as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }
//
// class NearbyPlacesScreen extends StatefulWidget {
//   final String hotelId;
//   final String nearbyCategoryId;
//
//   const NearbyPlacesScreen({
//     Key? key,
//     required this.hotelId,
//     required this.nearbyCategoryId,
//   }) : super(key: key);
//
//   @override
//   _NearbyPlacesScreenState createState() => _NearbyPlacesScreenState();
// }
//
// class _NearbyPlacesScreenState extends State<NearbyPlacesScreen> {
//   String _selectedNearbyCategory = 'restaurant'; // Default category
//   Place? _selectedPlace;
//   List<Place> _places = [];
//
//   @override
//   void initState() {
//     super.initState();
//     print('NearbyPlacesScreen initialized with hotelId: ${widget.hotelId}');
//     _fetchPlacesForNearbyCategory(_selectedNearbyCategory);
//   }
//
//   Future<List<Place>> fetchNearbyPlaces(String hotelId, String category) async {
//     print('Fetching nearby places for hotelId: $hotelId, category: $category');
//     try {
//       CollectionReference placesRef = FirebaseFirestore.instance
//           .collection('hotels')
//           .doc(hotelId)
//           .collection('nearby_places')
//           .doc(category)
//           .collection('places');
//
//       QuerySnapshot querySnapshot = await placesRef.get();
//       List<Place> places = querySnapshot.docs.map((doc) {
//         return Place.fromFirestore(doc);
//       }).toList();
//
//       print('Fetched ${places.length} places for category: $category');
//       return places;
//     } catch (e) {
//       print('Error fetching nearby places: $e');
//       return [];
//     }
//   }
//
//   void _fetchPlacesForNearbyCategory(String nearbyCategory) async {
//     print('Fetching places for selected category: $nearbyCategory');
//     final Map<String, String> nearbyCategoryToIdMap = {
//       'restaurant': 'restaurants',
//       'parking': 'parkings',
//       'hospital': 'hospitals',
//       'school': 'schools',
//     };
//
//     final nearbyCategoryId =
//         nearbyCategoryToIdMap[nearbyCategory] ?? widget.nearbyCategoryId;
//
//     final nearbyPlaces =
//     await fetchNearbyPlaces(widget.hotelId, nearbyCategoryId);
//
//     setState(() {
//       _places = nearbyPlaces;
//       _selectedPlace = null;
//     });
//   }
//
//   void _onNearbyCategorySelected(String nearbyCategory) {
//     print('Nearby category selected: $nearbyCategory');
//     setState(() {
//       _selectedNearbyCategory = nearbyCategory;
//     });
//     _fetchPlacesForNearbyCategory(nearbyCategory);
//   }
//
//   void _onPlaceSelected(Place place) {
//     print('Place selected: ${place.name}');
//     setState(() {
//       _selectedPlace = place;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('Building NearbyPlacesScreen...');
//     return Scaffold(
//       appBar: AppBar(title: Text('Nearby Places')),
//       body: Column(
//         children: [
//           _buildNearbyCategoryTabs(),
//           _buildMap(),
//           Expanded(child: _buildPlaceList()),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNearbyCategoryTabs() {
//     print('Building NearbyCategoryTabs...');
//     return Container(
//       height: 50.0,
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         children: [
//           _buildNearbyCategoryButton('restaurant', 'Restaurant'),
//           _buildNearbyCategoryButton('parking', 'Parking'),
//           _buildNearbyCategoryButton('hospital', 'Hospital'),
//           _buildNearbyCategoryButton('school', 'School'),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildNearbyCategoryButton(String nearbyCategory, String label) {
//     return GestureDetector(
//       onTap: () => _onNearbyCategorySelected(nearbyCategory),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         alignment: Alignment.center,
//         child: Text(
//           label,
//           style: TextStyle(
//             fontWeight: _selectedNearbyCategory == nearbyCategory
//                 ? FontWeight.bold
//                 : FontWeight.normal,
//             color: _selectedNearbyCategory == nearbyCategory
//                 ? AppTheme.accentColor
//                 : Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlaceList() {
//     print('Building PlaceList with ${_places.length} places...');
//     return ListView.builder(
//       itemCount: _places.length,
//       itemBuilder: (context, index) {
//         final place = _places[index];
//         return ListTile(
//           title: Text(place.name),
//           subtitle: Text("Rating: ${place.rating.toStringAsFixed(1)} ⭐"),
//           onTap: () => _onPlaceSelected(place),
//         );
//       },
//     );
//   }
//
//   Widget _buildMap() {
//     print('Building Map widget...');
//     if (_selectedPlace == null) {
//       return Container(
//         height: 200.0,
//         child: Center(child: Text('Select a place to view on the map')),
//       );
//     }
//
//     return Container(
//       height: 200.0,
//       child: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: LatLng(
//             _selectedPlace!.geometry.location.lat,
//             _selectedPlace!.geometry.location.lng,
//           ),
//           zoom: 14.0,
//         ),
//         markers: {
//           Marker(
//             markerId: MarkerId(_selectedPlace!.placeId),
//             position: LatLng(
//               _selectedPlace!.geometry.location.lat,
//               _selectedPlace!.geometry.location.lng,
//             ),
//             infoWindow: InfoWindow(title: _selectedPlace!.name),
//           ),
//         },
//       ),
//     );
//   }
// }

class Place {
  final String placeId;
  final String name;
  final double rating;
  final String type;
  final Geometry geometry;

  Place({
    required this.placeId,
    required this.name,
    required this.rating,
    required this.type,
    required this.geometry,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['place_id'] as String,
      name: json['name'] as String,
      rating: json['rating']?.toDouble() ?? 0.0,
      type: json['type'] as String,
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'name': name,
      'rating': rating,
      'type': type,
      'geometry': geometry.toJson(),
    };
  }

  factory Place.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Place.fromJson(data);
  }
}

class Geometry {
  final Location location;

  Geometry({required this.location});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: Location.fromJson(json['location']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
    };
  }
}

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'] as double,
      lng: json['lng'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class CustomLatLng {
  final double lat;
  final double lng;

  CustomLatLng({
    required this.lat,
    required this.lng,
  });

  factory CustomLatLng.fromJson(Map<String, dynamic> json) {
    return CustomLatLng(
      lat: json['lat'] as double,
      lng: json['lng'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class Viewport {
  final CustomLatLng northeast;
  final CustomLatLng southwest;

  Viewport({
    required this.northeast,
    required this.southwest,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      northeast:
      CustomLatLng.fromJson(json['northeast'] as Map<String, dynamic>),
      southwest:
      CustomLatLng.fromJson(json['southwest'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'northeast': northeast.toJson(),
      'southwest': southwest.toJson(),
    };
  }
}

class NearbyCategory {
  final String categoryName;
  final List<Place> places;

  NearbyCategory({
    required this.categoryName,
    required this.places,
  });

  factory NearbyCategory.fromFirestore(QuerySnapshot querySnapshot) {
    List<Place> places = querySnapshot.docs.map((doc) {
      return Place.fromFirestore(doc);
    }).toList();

    return NearbyCategory(
      categoryName: querySnapshot.docs.isNotEmpty
          ? querySnapshot.docs.first.reference.parent.parent!.id
          : '',
      places: places,
    );
  }
  // Convert NearbyCategory to JSON
  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'places': places.map((place) => place.toJson()).toList(),
    };
  }

  // Factory method to create NearbyCategory from JSON
  static NearbyCategory fromJson(Map<String, dynamic> json) {
    return NearbyCategory(
      categoryName: json['categoryName'] as String,
      places: (json['places'] as List<dynamic>)
          .map((placeJson) => Place.fromJson(placeJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

class NearbyPlaces {
  final List<NearbyCategory> nearbyCategories;

  NearbyPlaces({
    required this.nearbyCategories,
  });

  static Future<NearbyPlaces> fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) async {
    List<NearbyCategory> nearbyCategories = [];

    final nearbyPlacesCollection = doc.reference.collection('nearby_places');
    final categoriesSnapshots = await nearbyPlacesCollection.get();

    for (var categorySnapshot in categoriesSnapshots.docs) {
      final placesCollection = categorySnapshot.reference.collection('places');
      final placesSnapshots = await placesCollection.get();
      nearbyCategories.add(NearbyCategory.fromFirestore(placesSnapshots));
    }
    return NearbyPlaces(nearbyCategories: nearbyCategories);
  }

  // Convert NearbyPlaces to JSON
  Map<String, dynamic> toJson() {
    return {
      'nearbyCategories':
      nearbyCategories.map((category) => category.toJson()).toList(),
    };
  }

  // Factory method to create NearbyPlaces from JSON
  static NearbyPlaces fromJson(Map<String, dynamic> json) {
    return NearbyPlaces(
      nearbyCategories: (json['nearbyCategories'] as List<dynamic>)
          .map((categoryJson) =>
          NearbyCategory.fromJson(categoryJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

class NearbyPlacesScreen extends StatefulWidget {
  final String hotelId;
  final String nearbyCategoryId;

  const NearbyPlacesScreen({
    Key? key,
    required this.hotelId,
    required this.nearbyCategoryId,
  }) : super(key: key);

  @override
  _NearbyPlacesScreenState createState() => _NearbyPlacesScreenState();
}

class _NearbyPlacesScreenState extends State<NearbyPlacesScreen> {
  String _selectedNearbyCategory = 'restaurant'; // Default category
  Place? _selectedPlace;
  List<Place> _places = [];

  @override
  void initState() {
    super.initState();
    _fetchPlacesForNearbyCategory(_selectedNearbyCategory);
  }

  Future<List<Place>> fetchNearbyPlaces(String hotelId, String category) async {
    try {
      CollectionReference placesRef = FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotelId)
          .collection('nearby_places')
          .doc(category)
          .collection('places');

      QuerySnapshot querySnapshot = await placesRef.get();
      List<Place> places = querySnapshot.docs.map((doc) {
        return Place.fromFirestore(doc);
      }).toList();

      return places;
    } catch (e) {
      print('Error fetching nearby places: $e');
      return [];
    }
  }

  void _fetchPlacesForNearbyCategory(String nearbyCategory) async {
    final Map<String, String> nearbyCategoryToIdMap = {
      'restaurant': 'restaurants',
      'parking': 'parkings',
      'hospital': 'hospitals',
      'school': 'schools',
    };

    final nearbyCategoryId =
        nearbyCategoryToIdMap[nearbyCategory] ?? widget.nearbyCategoryId;

    final nearbyPlaces =
    await fetchNearbyPlaces(widget.hotelId, nearbyCategoryId);

    setState(() {
      _places = nearbyPlaces;
      _selectedPlace = null;
    });
  }

  void _onNearbyCategorySelected(String nearbyCategory) {
    setState(() {
      _selectedNearbyCategory = nearbyCategory;
    });
    _fetchPlacesForNearbyCategory(nearbyCategory);
  }

  void _onPlaceSelected(Place place) {
    setState(() {
      _selectedPlace = place;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nearby Places')),
      body: Column(
        children: [
          _buildNearbyCategoryTabs(),
          _buildMap(),
          Expanded(child: _buildPlaceList()),
        ],
      ),
    );
  }

  Widget _buildNearbyCategoryTabs() {
    return Container(
      height: 50.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildNearbyCategoryButton('restaurant', 'Restaurant'),
          _buildNearbyCategoryButton('parking', 'Parking'),
          _buildNearbyCategoryButton('hospital', 'Hospital'),
          _buildNearbyCategoryButton('school', 'School'),
        ],
      ),
    );
  }

  Widget _buildNearbyCategoryButton(String nearbyCategory, String label) {
    return GestureDetector(
      onTap: () => _onNearbyCategorySelected(nearbyCategory),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: _selectedNearbyCategory == nearbyCategory
                ? FontWeight.bold
                : FontWeight.normal,
            color: _selectedNearbyCategory == nearbyCategory
                ? AppTheme.accentColor
                : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceList() {
    return ListView.builder(
      itemCount: _places.length,
      itemBuilder: (context, index) {
        final place = _places[index];
        return ListTile(
          title: Text(place.name),
          subtitle: Text("Rating: ${place.rating.toStringAsFixed(1)} ⭐"),
          onTap: () => _onPlaceSelected(place),
        );
      },
    );
  }

  Widget _buildMap() {
    if (_selectedPlace == null) {
      return Container(
        height: 200.0,
        child: Center(child: Text('Select a place to view on the map')),
      );
    }

    return Container(
      height: 200.0,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _selectedPlace!.geometry.location.lat,
            _selectedPlace!.geometry.location.lng,
          ),
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId(_selectedPlace!.placeId),
            position: LatLng(
              _selectedPlace!.geometry.location.lat,
              _selectedPlace!.geometry.location.lng,
            ),
            infoWindow: InfoWindow(title: _selectedPlace!.name),
          ),
        },
      ),
    );
  }
}
class NearbyPlacesTab extends StatelessWidget {
  final Hotel hotel;
  final double latitude;
  final double longitude;
  final String hotelId;
  final String nearbyCategoryId;

  NearbyPlacesTab({
    required this.hotel,
    required this.latitude,
    required this.longitude,
    required this.hotelId,
    required this.nearbyCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    // Debugging print statement
    print(
        'NearbyPlacesTab: hotelId: $hotelId, nearbyCategoryId: $nearbyCategoryId');

    // Ensure hotelId and categoryId are valid
    if (hotelId.isEmpty || nearbyCategoryId.isEmpty) {
      print('Error: hotelId or nearbyCategoryId is empty or null');
      return const Center(
        child: Text('Error: Invalid hotel or nearbyCategory ID'),
      );
    }

    return NearbyPlacesScreen(
      hotelId: hotelId,
      nearbyCategoryId: nearbyCategoryId,
    );
  }
}
