import 'package:flutter/material.dart';

class ScrollupButton extends StatelessWidget {
  final ScrollController scrollController;

  const ScrollupButton({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        scrollController.animateTo(
          0,
          duration: Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      },
      child: Icon(Icons.arrow_upward),
    );
  }
}
