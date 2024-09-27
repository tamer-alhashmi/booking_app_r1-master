
import 'package:flutter/material.dart';



import '../../../theme/app_theme.dart';
import '../../hotel.dart';

// Chick-in & Chick-out Container
class DateSelectionWidget extends StatefulWidget {
  const DateSelectionWidget(
      {Key? key, required Hotel hotel, required this.onDatesSelected})
      : super(key: key);

  final Function(DateTime? checkInDate, DateTime? checkOutDate, int nights)
      onDatesSelected;

  @override
  _DateSelectionWidgetState createState() => _DateSelectionWidgetState();
}

class _DateSelectionWidgetState extends State<DateSelectionWidget> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  int calculateNights() {
    if (_checkInDate != null && _checkOutDate != null) {
      final Duration difference = _checkOutDate!.difference(_checkInDate!);
      return difference.inDays;
    }
    return 0;
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = pickedDate;
        } else {
          _checkOutDate = pickedDate;
        }

        final int nights = calculateNights();
        widget.onDatesSelected(_checkInDate, _checkOutDate, nights);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0, left: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, true),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      border: Border.all(color: AppTheme.primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Check-in',
                          // style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        _checkInDate == null
                            ? const Text(
                                'Select Date',
                                style: TextStyle(
                                    color: Colors.black),
                              )
                            : Text(
                                '${_checkInDate!.toLocal()}'.split(' ')[0],
                                style: const TextStyle(
                                    color: AppTheme.accentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () => _selectDate(context, false),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration:  BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      // border: Border.all(color: AppTheme.buiColorCtaBackground),
                      // borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Check-out',

                        ),
                        _checkOutDate == null
                            ?  const Text(
                                'Select Date',
                                style: TextStyle(
                                    color: Colors.black),
                              )
                            : Text(
                                '${_checkOutDate!.toLocal()}'.split(' ')[0],
                                style: const TextStyle(
                                    color: AppTheme.secondaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
