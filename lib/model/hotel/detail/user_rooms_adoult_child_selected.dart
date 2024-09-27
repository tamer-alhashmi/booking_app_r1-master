import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../hotel.dart';



class RoomsAndGuestsSelector extends StatefulWidget {
  final Hotel hotel;

  const RoomsAndGuestsSelector(
      {super.key, required this.onSelectionChanged, required this.hotel});
  final Function(int, int, int) onSelectionChanged;
  @override
  _RoomsAndGuestsSelectorState createState() => _RoomsAndGuestsSelectorState();
}

class _RoomsAndGuestsSelectorState extends State<RoomsAndGuestsSelector> {
  int userRoomSelected = 1;
  int userAdultSelected = 1;
  int userChildrenSelected = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showSelectorDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppTheme.primaryColor.withOpacity(0.1),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rooms and guests',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '$userRoomSelected rooms',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 8),
                Text(
                  '$userAdultSelected adults',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 8),
                Text(
                  '$userChildrenSelected children',
                  style: TextStyle(color: AppTheme.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSelectorDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Rooms and Guests Selector'),
                content: Column(
                  children: [
                    // Your dialog content goes here
                    // You can include sliders, buttons, or any other UI elements
                    // to allow the user to select the number of rooms and guests
                    // For example:
                    const Text(' Number of Rooms:'),
                    Slider(
                      value: userRoomSelected.toDouble(),
                      autofocus: true,
                      min: 1,
                      max: 10,
                      onChanged: (value) {
                        setState(() {
                          userRoomSelected = value.toInt();
                        });
                      },
                    ),
                    const Text('Number of Person:'),
                    Slider(
                      value: userAdultSelected.toDouble(),
                      autofocus: true,
                      min: 1,
                      max: 20,
                      onChanged: (value) {
                        setState(() {
                          userAdultSelected = value.toInt();
                        });
                      },
                    ),
                    const Text('Number of Children:'),
                    Slider(
                      value: userChildrenSelected.toDouble(),
                      autofocus: true,
                      min: 1,
                      max: 5,
                      onChanged: (value) {
                        setState(() {
                          userChildrenSelected = value.toInt();
                        });
                      },
                    ),
                    // Repeat similar logic for adult and children selection
                    // ...
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      // Call the callback function with the selected values
                      widget.onSelectionChanged(
                        userRoomSelected,
                        userAdultSelected,
                        userChildrenSelected,
                      );
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }
}
