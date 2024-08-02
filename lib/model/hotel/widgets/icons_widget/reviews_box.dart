
import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/theme/app_theme.dart';
import 'package:flutter/material.dart';




class ReviewsBox extends StatelessWidget {
  const ReviewsBox({Key? key, required this.hotel}) : super(key: key);

  final Hotel hotel;
  String get starRate => hotel.starRate;

  // final String starRate = HotelElement.starRate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      margin: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
            bottomRight: Radius.circular(6)),
      ),
      child: Center(
        child: Text(
          starRate,
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
