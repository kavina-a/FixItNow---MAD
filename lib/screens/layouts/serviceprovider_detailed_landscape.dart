// import 'package:flutter/material.dart';
// import '../../models/sp-detailed.dart';  // Import the detailed model
// import '../categories/booknow.dart';
// import '../widgets/styles.dart';
//
// class ServiceProviderLandscape extends StatelessWidget {
//   final ServiceProviderDetail providerDetail;
//   final String serviceType;
//
//   const ServiceProviderLandscape({
//     Key? key,
//     required this.providerDetail,
//     required this.serviceType,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Profile and Basic Info
//         Expanded(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 80,
//                   backgroundImage: providerDetail.profileImage != null
//                       ? NetworkImage(providerDetail.profileImage!)
//                       : const AssetImage('assets/placeholder.png') as ImageProvider,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   '${providerDetail.firstName} ${providerDetail.lastName}',
//                   style: TextStyles.headlineLarge,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Expanded(
//           flex: 2,
//           child: Padding(
//             padding: const EdgeInsets.all(40.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InfoCard(
//                       icon: Icons.location_on,
//                       text: 'Distance\n${providerDetail.distance ?? 'Unknown'} away',
//                     ),
//                     InfoCard(
//                       icon: Icons.timer,
//                       text: 'Est. Delivery Time\n${providerDetail.estimatedTime ?? 'Unknown'}',
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     InfoCard(
//                       icon: Icons.home_work,
//                       text: 'Reviews\n(231)',
//                     ),
//                     InfoCard(
//                       icon: Icons.school,
//                       text: 'Experience\n${providerDetail.yearsOfExperience} year/s',
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 25),
//                 Divider(),
//                 Text(
//                   "About Me -",
//                   style: TextStyles.headlineLarge,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   providerDetail.description,
//                   style: TextStyles.bodyMedium,
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: providerDetail.availability
//                             ? () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AppointmentForm(
//                                 serviceProviderId: providerDetail.id,
//                                 serviceType: serviceType,
//                                 serviceProviderName: providerDetail.firstName,
//                               ),
//                             ),
//                           );
//                         }
//                             : null,
//                         child: Material(
//                           elevation: 5,
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(100),
//                           ),
//                           child: Container(
//                             height: 60,
//                             decoration: BoxDecoration(
//                               color: providerDetail.availability
//                                   ? TextStyles.primaryColor
//                                   : Colors.grey,
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(100),
//                               ),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 providerDetail.availability
//                                     ? "Book Now"
//                                     : "Not Available",
//                                 style: TextStyles.customTextStyle,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
