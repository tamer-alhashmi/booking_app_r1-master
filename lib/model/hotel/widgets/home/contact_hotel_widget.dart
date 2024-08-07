import 'package:booking_app_r1/features/user_auth/firebase_auth_impelmentation/auth_service.dart';
import 'package:booking_app_r1/model/hotel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactHotelWidget extends StatefulWidget {
  final Hotel hotel;

  const ContactHotelWidget({required this.hotel});

  @override
  _ContactHotelWidgetState createState() => _ContactHotelWidgetState();
}

class _ContactHotelWidgetState extends State<ContactHotelWidget> {
  late AuthService _authService;
  String _firstName = '';
  String _lastName = '';
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _loadUserData();
  }

  void _loadUserData() async {
    final userDetails = await _authService.getUserDetails();
    setState(() {
      _firstName = userDetails['firstName'] ?? '';
      _lastName = userDetails['lastName'] ?? '';
      _userId = userDetails['userId'] ?? '';
    });
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
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.grey.shade200, // Add background color here
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              iconSize: 30,
              icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
              onPressed: () {
                final whatsappMessage = Uri.encodeComponent(
                    'Hi, I am interested in your property at ${widget.hotel.name} Hotel,\nLocated at ${widget.hotel.address}.\nName: $_firstName $_lastName.'
                );
                final whatsappUrl = 'https://wa.me/${widget.hotel.whatsapp}?text=$whatsappMessage';
                launchUrl(Uri.parse(whatsappUrl));
              },
            ),
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.email, color: Colors.blue),
              onPressed: () {
                final emailMessage = Uri.encodeComponent(
                    'Hi, I am interested in your property at ${widget.hotel.name} Hotel,\nLocated at ${widget.hotel.address}.\nName: $_firstName $_lastName'
                );
                final emailUrl = 'mailto:${widget.hotel.email}?subject=Property Inquiry&body=$emailMessage';
                launchUrl(Uri.parse(emailUrl));
              },
            ),
            IconButton(
              iconSize: 30,
              icon: Icon(Icons.phone, color: Colors.black),
              onPressed: () {
                final phoneUrl = 'tel:${widget.hotel.phone}';
                launchUrl(Uri.parse(phoneUrl));
              },
            ),
          ],
        ),
      ),
    );
  }
}
