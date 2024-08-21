import 'package:booking_app_r1/services/nearby_places.dart';
import 'package:flutter/material.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/widgets/policy_widget.dart';
import 'package:booking_app_r1/model/amenities.dart';

import '../../../../theme/app_theme.dart';
import '../../widgets/hotel_reviews_card_widget.dart';

class NavigationTabs extends StatefulWidget {
  final Hotel hotel;
  final int initialTabIndex;
  final double latitude;
  final double longitude;
  final String hotelId;
  final String nearbyCategoryId;
  // final String categoryId;

  NavigationTabs(
      {required this.hotel,
      required this.initialTabIndex,
      required this.latitude,
      required this.longitude,
      required this.hotelId,
        required this.nearbyCategoryId,
      // required this.categoryId
      });

  @override
  _NavigationTabsState createState() => _NavigationTabsState();
}

class _NavigationTabsState extends State<NavigationTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 6, vsync: this, initialIndex: widget.initialTabIndex);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {}); // Update the state when a tab is selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.hotel.name} Hotel'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints(maxHeight: 150.0),
            child: Material(
              color: AppTheme.primaryColor, // Choose your desired color
              child: TabBar(
                dividerColor: AppTheme.accentColor,
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors
                    .white, // Set the color of the active tab label to white
                tabs: const [
                  Tab(text: 'Description'),
                  Tab(text: 'Facilities'),
                  Tab(text: 'Policies'),
                  Tab(text: 'Children & Extra Beds'),
                  Tab(text: 'Nearby Places'),
                  Tab(text: 'Reviews'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              viewportFraction: 1,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              controller: _tabController,
              children: [
                DescriptionTab(hotel: widget.hotel),
                FacilitiesTab(hotel: widget.hotel),
                PoliciesTab(hotel: widget.hotel),
                ChildrenExtraBedsTab(hotel: widget.hotel),
                NearbyPlacesTab(
                  hotel: widget.hotel,
                  latitude: widget.latitude,
                  longitude: widget.longitude,
                  hotelId: widget.hotelId,
                  nearbyCategoryId: widget.nearbyCategoryId,
                ),
                ReviewsTab(hotel: widget.hotel),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DescriptionTab extends StatelessWidget {
  final Hotel hotel;

  DescriptionTab({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(hotel.description),
      ),
    );
  }
}

class FacilitiesTab extends StatelessWidget {
  final Hotel hotel;

  FacilitiesTab({required this.hotel});

  @override
  Widget build(BuildContext context) {
    // Implement the UI to display facilities
    return Center(
      child: HotelAmenities(
        amenities: hotel.facilities,
        hotel: hotel,
      ),
    );
  }
}

class PoliciesTab extends StatelessWidget {
  final Hotel hotel;

  PoliciesTab({required this.hotel});

  @override
  Widget build(BuildContext context) {
    // Implement the UI to display policies
    return Center(
      child: PoliciesWidget(
        policies: hotel.policies,
        hotel: hotel,
      ),
    );
  }
}

class ChildrenExtraBedsTab extends StatelessWidget {
  final Hotel hotel;

  ChildrenExtraBedsTab({required this.hotel});

  @override
  Widget build(BuildContext context) {
    // Implement the UI to display children & extra beds information
    return const Center(
      child: Text('Children & Extra Beds Tab'),
    );
  }
}




class ReviewsTab extends StatelessWidget {
  final Hotel hotel;

  ReviewsTab({required this.hotel});

  @override
  Widget build(BuildContext context) {
    if (hotel.id.isEmpty) {
      print('Error: hotelId is empty or null');
      return const Center(
        child: Text('Error: Invalid hotel ID'),
      );
    }

    return Center(
      child: HotelReviewsCardScreen(
        hotelId: hotel.id, // Make sure this is not an empty string
      ),
    );
  }
}
