import 'package:booking_app_r1/model/category/hotel_categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  static Future<List<Category>> fetchCategoriesForHotel(String hotelId) async {
    List<Category> categories = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('hotelId', isEqualTo: hotelId)
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        categories.add(Category.fromFirestore(doc.data() as Map<String, dynamic>, doc.id));
      }
    } catch (e) {
      print("Error fetching categories: $e");
    }

    return categories;
  }
}