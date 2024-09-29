// import 'package:flutter/material.dart';
//
// import 'hotel.dart';
// import 'policies.dart';
//
// class HotelPoliciesWidget extends StatelessWidget {
//   final Hotel hotel;
//   final HotelPolicies policies;
//
//   const HotelPoliciesWidget({Key? key, required this.policies, this.hotel})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Policies:',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 4),
//               child: Text('Check in: ${policies.checkIn}'),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 4),
//               child: Text('Check out: ${policies.checkOut}'),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 4),
//               child: Text('Accommodation Type: ${policies.accommodationType}'),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 4),
//               child: Text('Pet Policy: ${policies.petPolicy}'),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:booking_app_r1/model/hotel.dart';
import 'package:booking_app_r1/model/hotel/detail/navigate_tab_bar/navigation-tabs.dart';
import 'package:booking_app_r1/model/hotel/detail/policies.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

class PoliciesWidget extends StatelessWidget {
  final Hotel hotel;

  final HotelPolicies policies;

  const PoliciesWidget(
      {Key? key, required this.policies, required this.hotel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Policies:',
          style: AppTheme.sectionTitleTextStyle,
        ),
        const SizedBox(height: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
               children: [
                 const Text('Check-in: ',style: AppTheme.bodyTextStyle,),
                 Text(policies.checkIn, style: AppTheme.bodyTextStyle,)
               ],
             ),
            Row(
              children: [
                const Text('Check-out: ',style: AppTheme.bodyTextStyle,),
                Text(policies.checkOut,style: AppTheme.bodyTextStyle,),
              ],
            ),
            Row(
              children: [
                const Text('Accommodation Type: ',style: AppTheme.bodyTextStyle,),
                Text(policies.accommodationType,style: AppTheme.bodyTextStyle),
              ],
            ),
            Row(
              children: [
                const Text('Pet Policy: ',style: AppTheme.bodyTextStyle),
                Text( policies.petPolicy,style: AppTheme.bodyTextStyle),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class HotelPoliciesCardWidget extends StatelessWidget {
  final Hotel hotel;
  final double latitude;
  final double longitude;
  final String hotelId;

  final HotelPolicies policies;

  const HotelPoliciesCardWidget(
      {Key? key,
      required this.policies,
      required this.hotel,
      required this.latitude,
      required this.longitude, required this.hotelId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Policies:',
            style: AppTheme.headlineTextStyle,
          ),
          // const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('Check-in: ${policies.checkIn}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('Check-out: ${policies.checkOut}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('Accommodation Type: ${policies.accommodationType}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('Pet Policy: ${policies.petPolicy}', style: AppTheme.bodyTextStyle,),
                ),

              ],

            ),

          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavigationTabs(
                      hotel: hotel,
                      initialTabIndex: 2,
                      latitude: latitude,
                      longitude: longitude,
                      hotelId: hotelId,
                      nearbyCategoryId: '',
                      // categoryId: '', // Index of the Facilities tab
                    ),
                  ),
                );
              },
              child: const Text(
                'Read Policy',
                style: AppTheme.linkTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
