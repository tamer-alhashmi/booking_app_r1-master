import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/model/category/hotel_categories.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/widgets/bottom_bar/bottom_navigate_bar.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  final AuthService authService;
  final List<Category> categories;
  final Hotel hotel;
  final int currentPageIndex;
  final Function(int) onPageChanged;
  final Map<String, dynamic> userDetails;
  final double latitude;
  final double longitude;

  FavoriteScreen({
    Key? key,
    required this.currentPageIndex,
    required this.onPageChanged,
    required this.categories,
    required this.hotel,
    required this.userDetails,
    required this.authService,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late String _firstName = '';
  late String _lastName = '';
  Map<String, dynamic> _userDetails = {};
  int currentPageIndex = 1;

  late List<Hotel> _favoriteHotels = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadFavoriteHotels();
  }

  Future<void> _loadFavoriteHotels() async {
    try {
      final List<Hotel> favoriteHotels =
          await widget.authService.getFavoriteHotels(widget.userDetails['userId']);
      setState(() {
        _favoriteHotels = favoriteHotels;
      });
    } catch (error) {
      print('Error loading favorite hotels: $error');
    }
  }

  Future<void> _loadUserData() async {
    Map<String, dynamic> userDetails =
        await widget.authService.getUserDetails(_userDetails);
    setState(() {
      _userDetails = userDetails;
      _firstName = userDetails['firstname'] ?? '';
      _lastName = userDetails['lastname'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Screen'),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentPageIndex: currentPageIndex,
        onPageChanged: widget.onPageChanged,
        categories: widget.categories,
        hotel: widget.hotel,
        userDetails: widget.userDetails,
        authService: widget.authService,
        firstName: _firstName, longitude: widget.longitude, latitude: widget.latitude, userId: '',
      ),
      body: _favoriteHotels.isEmpty
          ? Center(child: Text('No favorite hotels found.'))
          : ListView.builder(
              itemCount: _favoriteHotels.length,
              itemBuilder: (context, index) {
                final Hotel hotel = _favoriteHotels[index];
                return ListTile(
                  title: Text(hotel.name),
                  subtitle: Text(hotel.address),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _removeFromFavorites(hotel);
                    },
                  ),
                );
              },
            ),
    );
  }

  void _removeFromFavorites(Hotel hotel) {
    setState(() {
      _favoriteHotels.remove(hotel);
    });
    widget.authService.removeUserFavorite(widget.userDetails['userId'] , hotel.id as String);
  }
}
