import 'package:booking_app_r1/model/hotel/full_screen_image_page.dart';
import 'package:flutter/material.dart';

class HotelSliderWidget extends StatefulWidget {
  final String hotelName;
  final String sliderpics;

  const HotelSliderWidget({Key? key, required this.hotelName, required this.sliderpics}) : super(key: key);

  @override
  _HotelSliderWidgetState createState() => _HotelSliderWidgetState();
}

class _HotelSliderWidgetState extends State<HotelSliderWidget> {
  late Future<List<String>> sliderImagesFuture;

  @override
  void initState() {
    super.initState();
    // sliderImagesFuture = HotelService.fetchHotelImagesFromStorage(widget.hotelName, widget.sliderpics);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: sliderImagesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No images available'));
        } else {
          final sliderpics = snapshot.data!;
          return SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sliderpics.length > 6 ? 6 : sliderpics.length,
              itemBuilder: (context, index) {
                final imageUrl = sliderpics[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImagePage(
                          images: sliderpics,
                          initialIndex: index,
                          sliderpics: sliderpics, // Pass the images list to the full-screen page
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 120, // Adjust the width of each photo here
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
