import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/features/user_auth/presentation/pages/user/user_details.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../model/hotel/widgets/bottom_bar/bottom_navigate_bar.dart';

class FavoriteScreen extends StatefulWidget {
  final AuthService authService;
  final Category category;
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
    required this.category,
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
  bool _isLoading = true;

  Map<String, dynamic> _userDetails = {};
  List<Hotel> _favoriteHotels = [];
  String _firstName = '';
  String _lastName = '';
  int currentPageIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadFavoriteHotels();
  }

  Future<void> _loadFavoriteHotels() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Access userId from the userDetails map
      final String userId = widget.userDetails['userId'] ?? '';
      if (userId.isNotEmpty) {
        final List<Hotel> favoriteHotels = await widget.authService.getFavoriteHotels(userId);
        setState(() {
          _favoriteHotels = favoriteHotels;
        });
      } else {
        print('No userId found in userDetails');
      }
    } catch (error) {
      print('Error loading favorite hotels: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic> userDetails = await widget.authService.getUserDetails() as Map<String, dynamic>;
      setState(() {
        _userDetails = userDetails;
        _firstName = userDetails['firstName'] ?? '';
        _lastName = userDetails['lastName'] ?? '';
      });
    } catch (error) {
      print('Error loading user data: $error');
    }
  }
  void _removeFromFavorites(Hotel hotel) {
    setState(() {
      _favoriteHotels.remove(hotel);
    });

    final String userId = widget.userDetails['userId'] ?? '';
    if (userId.isNotEmpty) {
      widget.authService.removeUserFavorite(userId, hotel.id as String);
    } else {
      print('UserId not found');
    }
  }
  @override
  Widget build(BuildContext context) {
    // Move userDataService inside the build method
    // final userDataService = Provider.of<UserDataService>(context);

    return FutureBuilder(
      future: widget.authService.getFavoriteHotels(
          widget.userDetails['userId']),
      builder: (context, AsyncSnapshot<List<Hotel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No favorite hotels found.'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final hotel = snapshot.data![index];
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
          );
        }
      },
    );
  }

  }
