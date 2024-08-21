import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/model/category/category.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactToolWidget extends StatefulWidget {
  final Hotel hotel;
  final Category category;


  const ContactToolWidget({required this.hotel, required this.category});

  @override
  _ContactToolWidgetState createState() => _ContactToolWidgetState();
}

class _ContactToolWidgetState extends State<ContactToolWidget> {
  late AuthService _authService;
  String _firstName = '';
  String _lastName = '';
  String _userId = '';
  String _profilePhotoUrl = '';
  bool hasNotification = false;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final authService = AuthService();
      final userDetails = await authService.getUserDetails();

      setState(() {
        _firstName = userDetails?.firstName ?? '';
        _lastName = userDetails?.lastName ?? '';
        _profilePhotoUrl = userDetails?.profilePhotoUrl ?? '';
        hasNotification = userDetails?.hasNotification ?? false;
      });
    } catch (e) {
      // Handle any errors that occur during the fetch
      print("Error loading user data: $e");

      // Optionally, set default values in case of error
      setState(() {
        _firstName = '';
        _lastName = '';
        _profilePhotoUrl = '';
        hasNotification = false;
      });
    }
  }

  Future<void> launch(Uri uri) async {
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString() as Uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor,
              borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
            ),
            child: SizedBox(
              width: 100, // Adjust the width as needed
              height: 50,
              child: IconButton(
                iconSize: 30,
                icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                onPressed: () {
                  final whatsappMessage = Uri.encodeComponent(
                      'Hi, I am interested in your ${widget.hotel.name} Hotel,\nWith a ${widget.category.catFullName}.\nName: $_firstName $_lastName.'
                  );
                  final whatsappUrl = 'https://wa.me/${widget.hotel.whatsapp}?text=$whatsappMessage';
                  launchUrl(Uri.parse(whatsappUrl));
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor,
              borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
            ),
            child: SizedBox(
              width: 100, // Adjust the width as needed
              height: 50,
              child: IconButton(
                iconSize: 30,
                icon: const Icon(Icons.email, color: Colors.blue),
                onPressed: () {
                  final emailMessage = Uri.encodeComponent(
                      'Hi, I am interested in your property at ${widget.hotel.name} Hotel,\nLocated at ${widget.hotel.address}.\nName: $_firstName $_lastName'
                  );
                  final emailUrl = 'mailto:${widget.hotel.email}?subject=Property Inquiry&body=$emailMessage';
                  launchUrl(Uri.parse(emailUrl));
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor,
              borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
            ),
            child: SizedBox(
              width: 100, // Adjust the width as needed
              height: 50,
              child: IconButton(
                iconSize: 30,
                icon: const Icon(Icons.phone, color: Colors.black),
                onPressed: () {
                  final phoneUrl = 'tel:${widget.hotel.phone}';
                  launchUrl(Uri.parse(phoneUrl));
                },
              ),
            ),
          ),
        ],
      ),

    );
  }
}
