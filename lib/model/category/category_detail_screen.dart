import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/widgets/home/contact_tool_widget.dart';
import 'package:flutter/material.dart';
import 'category.dart'; // Import your Category model

class CategoryDetailScreen extends StatelessWidget {
  final Category category;
  final Hotel hotel;

  const CategoryDetailScreen(
      {Key? key, required this.category, required this.hotel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(category.catTitle),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (category.catProPicUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(category.catProPicUrl),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        category.catTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                      category.catFullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                  ),
                      const SizedBox(height: 16),
                      Text(
                        category.catHotelDescreption,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Bed Type: ${category.bedType}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Capacity: ${category.capacity}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Room Size: ${category.roomSize}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: category.amenities
                            .map((amenity) => Chip(
                          label: Text(amenity),
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                )),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: ContactToolWidget(
                category: category,
                hotel: hotel,
              ),
            )
          ],
        )
    );
  }
}
