import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/widgets/home/contact_tool_widget.dart';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
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
                        style: AppTheme.sectionTitleTextStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                      category.catFullName,
                      style: AppTheme.subheadTextStyle,
                  ),
                      const SizedBox(height: 16),
                      Text(
                        category.catHotelDescreption,
                        style: AppTheme.bodyTextStyle,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.bed, color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Bed Type: ${category.bedType}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.group, color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Capacity: ${category.capacity}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.square_foot,
                              color: AppTheme.primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Room Size: ${category.roomSize}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Amenities:',
                        style: AppTheme.subheadTextStyle,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: category.amenities.take(6).map((amenity) {
                          return Row(
                            mainAxisSize: MainAxisSize.min, // This ensures the row only takes the needed space
                            children: [
                              const Icon(
                                Icons.check, // Replace with any icon that matches the amenity
                                color: AppTheme.primaryColor,
                                size: 20.0, // Adjust the size of the icon
                              ),
                              const SizedBox(width: 4), // Add some space between icon and text
                              Text(
                                amenity,
                                style: const TextStyle(
                                  color: AppTheme.textColor,
                                  fontSize: 14.0, // Adjust the font size if needed
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 80,)
                    ],
                  ),
                )),
            // Positioned(
            //   bottom: 10,
            //   right: 10,
            //   left: 10,
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min, // Ensures the column only takes the needed space
            //     children: [
            //       Container(
            //         height: 1, // Thickness of the divider
            //         width: double.infinity, // Full width
            //         color: Colors.grey[350], // Gray color for the divider
            //       ),
            //       const SizedBox(height: 10), // Add some space between the divider and the widget
            //       ContactToolWidget(
            //         category: category,
            //         hotel: hotel,
            //       ),
            //     ],
            //   ),
            // )
            Positioned(
              bottom: 0,
              right: 10,
              left: 10,
              child: Container(
                color: Colors.white, // White background for the whole section
                // padding: const EdgeInsets.only(top: 10), // Optional padding for the top
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Ensures the column only takes the needed space
                  children: [
                    Container(
                      height: 2, // Thickness of the divider
                      width: double.infinity, // Full width
                      color: Colors.grey[250], // Gray color for the divider
                    ),
                    const SizedBox(height: 10), // Add some space between the divider and the widget
                    ContactToolWidget(
                      category: category,
                      hotel: hotel,
                    ),
                    const SizedBox(height: 10,)
                  ],
                ),
              ),
            )

          ],

        )
    );
  }
}
