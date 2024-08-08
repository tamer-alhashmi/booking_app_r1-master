
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String title;
  final String catFullName;
  final String description;
  final String fullDescription;
  final String bedType;
  final int capacity;
  final List<String> amenities;
  final String imageUrl;
  final String roomSize;
  final String catProPicUrl;

  Category({
    required this.id,
    required this.title,
    required this.catFullName,
    required this.description,
    required this.fullDescription,
    required this.bedType,
    required this.capacity,
    required this.amenities,
    required this.imageUrl,
    required this.roomSize,
    required this.catProPicUrl,
  });

  factory Category.fromFirestore(Map<String, dynamic> data, String docId) {
    return Category(
      id: docId,
      title: data['catTitle'] as String? ?? '',
      catFullName: data['catFullName'] as String? ?? '',
      description: data['catDescreption'] as String? ?? '',
      fullDescription: data['catHotelDescreption'] as String? ?? '',
      bedType: data['bedType'] as String? ?? '',
      capacity: (data['capacity'] as num?)?.toInt() ?? 0,
      amenities: List<String>.from(data['amenities'] as List<dynamic>? ?? []),
      imageUrl: data['imageUrl'] as String? ?? '',
      roomSize: data['roomSize'] as String? ?? '',
      catProPicUrl: data['catProPicUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'catTitle': title,
      'catFullName': catFullName,
      'catDescreption': description,
      'catHotelDescreption': fullDescription,
      'bedType': bedType,
      'capacity': capacity,
      'amenities': amenities,
      'imageUrl': imageUrl,
      'roomSize': roomSize,
      'catProPicUrl': catProPicUrl,
    };
  }
}
