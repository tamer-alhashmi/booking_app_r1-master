import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:booking_app_r1/services/hotel_service.dart';
import 'package:booking_app_r1/model/hotel.dart';

class HotelProvider with ChangeNotifier {
  List<Hotel> _hotels = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Hotel> get hotels => _hotels;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch all hotels from the service and update state.
  Future<void> fetchHotels() async {
    _setLoading(true);
    try {
      final response = await HotelService.fetchHotels();
      _setHotels(response);
    } catch (error) {
      _setError('Error fetching hotels: $error');
    } finally {
      _setLoading(false);
    }
  }

  /// Search hotels by city using the service and update state.
  Future<void> searchHotelsByCity(String city) async {
    _setLoading(true);
    try {
      final response = await HotelService.searchHotelsByCity(city);
      _setHotels(response);
    } catch (error) {
      _setError('Error searching hotels: $error');
    } finally {
      _setLoading(false);
    }
  }

  /// Update the favorite status of a hotel and sync with Firestore.
  Future<void> updateFavoriteStatus(Hotel hotel, bool isFavorite) async {
    try {
      hotel.isFavorite = isFavorite;
      await FirebaseFirestore.instance
          .collection('hotels')
          .doc(hotel.id)
          .update({'isFavorite': isFavorite});
      notifyListeners();
    } catch (error) {
      _setError('Error updating favorite status: $error');
    }
  }

  /// Refresh data by fetching hotels again.
  Future<void> refresh() async {
    await fetchHotels();
  }

  /// Set loading state and notify listeners.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Set hotels state and notify listeners.
  void _setHotels(List<Hotel> hotels) {
    _hotels = hotels;
    _errorMessage = null;
    notifyListeners();
  }

  /// Set error message and notify listeners.
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}
