class Category {
  final String id;
  final String catTitle;
  final String catFullName;
  final String catDescreption;
  final String catHotelDescreption;
  final String bedType;
  final int capacity; // This might be causing the error
  final List<String> amenities;
  final List<String> galleryUrl;
  final String roomSize;
  final String catProPicUrl;

  Category({
    required this.id,
    required this.catTitle,
    required this.catFullName,
    required this.catDescreption,
    required this.catHotelDescreption,
    required this.bedType,
    required this.capacity,
    required this.amenities,
    required this.galleryUrl,
    required this.roomSize,
    required this.catProPicUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json, String id) {
    return Category(
      id: json['id'] as String,
      catTitle: json['catTitle'] as String,
      catFullName: json['catFullName'] as String,
      catDescreption: json['catDescreption'] as String,
      catHotelDescreption: json['catHotelDescreption'] as String,
      bedType: json['bedType'] as String,
      capacity: json['capacity'] is int
          ? json['capacity'] as int
          : int.tryParse(json['capacity'].toString()) ?? 0,
      amenities: json['amenities'] != null
          ? List<String>.from(json['amenities'])
          : [], // Use an empty list if null
      galleryUrl: List<String>.from(json['galleryUrl'] ?? []),
      roomSize: json['roomSize'] as String,
      catProPicUrl: json['catProPicUrl'] as String,
    );
  }


  Map<String, dynamic> toJson() => {
    "id": id,
    "title": catTitle,
    "catFullName": catFullName,
    "catDescreption": catDescreption,
    "catHotelDescreption": catHotelDescreption,
    "bedType": bedType,
    "capacity": capacity,
    "amenities": amenities,
    "galleryUrl": galleryUrl,
    "roomSize": roomSize,
    "catProPicUrl": catProPicUrl,
  };
}
