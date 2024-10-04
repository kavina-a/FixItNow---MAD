// import 'package:flutter/material.dart';
// import '../../models/sp-detailed.dart';
// import '../widgets/styles.dart';
// import 'booknow.dart';
//
// class ServiceProviderPortrait extends StatelessWidget {
//   final ServiceProviderDetail providerDetail;
//   final String serviceType;
//
//   const ServiceProviderPortrait({
//     Key? key,
//     required this.providerDetail,
//     required this.serviceType,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Material(
//         type: MaterialType.transparency,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).colorScheme.background,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(50),
//               topRight: Radius.circular(50),
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(40),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Hero(
//                     tag: 'image-transition',
//                     child: CircleAvatar(
//                       radius: 100,
//                       backgroundImage: providerDetail.profileImage != null
//                           ? NetworkImage(providerDetail.profileImage!)
//                           : const AssetImage('assets/placeholder.png') as ImageProvider,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: Text(
//                     '${providerDetail.firstName} ${providerDetail.lastName}',
//                     style: TextStyles.headlineLarge,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: InfoCard(
//                         icon: Icons.location_on,
//                         text: 'Distance\n${providerDetail.distance ?? 'Unknown'} away',
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: InfoCard(
//                         icon: Icons.timer,
//                         text: 'Est. Delivery Time\n${providerDetail.estimatedTime ?? 'Unknown'}',
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: InfoCard(
//                         icon: Icons.home_work,
//                         text: 'Reviews\n(231)',
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: InfoCard(
//                         icon: Icons.school,
//                         text: 'Experience\n${providerDetail.yearsOfExperience} year/s',
//                       ),
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
//       ),
//     );
//   }
// }
