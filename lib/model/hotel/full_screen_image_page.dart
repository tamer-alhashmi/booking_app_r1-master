import 'package:flutter/material.dart';

class FullScreenImagePage extends StatelessWidget {
  final List<String> sliderpics;
  final int initialIndex;

  const FullScreenImagePage({
    Key? key,
    required this.sliderpics,
    required this.initialIndex,
    required images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            itemCount: sliderpics.length,
            controller: PageController(initialPage: initialIndex),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Go back when tapped
                },
                child: Image.network(
                  sliderpics[index],
                  fit: BoxFit.contain,
                ),
              );
            },
          ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Go back when tapped
              },
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.pop(context); // Go back when tapped
              },
            ),
          ),
        ],
      ),
    );
  }
}
