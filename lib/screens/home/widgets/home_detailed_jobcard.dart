// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fixitnow/screens/widgets/styles.dart';
// import 'package:flutter/widgets.dart';
//
// import '../../../models/sp-detailed.dart';
//
// class DetailedJobCard extends StatelessWidget {
//   final ServiceProviderDetail providerDetail;  // Accept the full provider model
//
//   const DetailedJobCard({Key? key, required this.providerDetail, required int serviceProviderId}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: TextStyles.primaryColor,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title:  Text(
//         'Worker Profile',
//         style: TextStyles.titleLarge
//         ),
//         actions: const [
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 Icons.share_outlined,
//                 size: 24,
//                 color: Colors.black,
//               ),
//               SizedBox(width: 14),
//               Icon(
//                 Icons.bookmark_border,
//                 size: 24,
//                 color: Colors.black,
//               ),
//               SizedBox(width: 14),
//               Icon(
//                 Icons.more_vert_rounded,
//                 size: 24,
//                 color: Colors.black,
//               ),
//               SizedBox(width: 16),
//
//             ],
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Material(
//           type: MaterialType.transparency,
//           child: Container(
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.background,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(50),
//                 topRight: Radius.circular(50),
//               ),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(40),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Center(
//                     child: Hero(
//                       tag: 'image-transition',
//                       child: CircleAvatar(
//                         radius: 100,
//                         backgroundImage: AssetImage('asset/workerpic2.jpg'),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 20),
//
//                    Center(
//                     child: Text(
//                       'Sam',
//                       style: TextStyles.headlineLarge,
//                     ),
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Row(
//                         children: [
//                           InfoCard(
//                             icon: Icons.monetization_on,
//                             text: 'Delivery Time\n1 - 2 hours',
//                           ),
//                           SizedBox(width: 8),
//                           InfoCard(
//                             icon: Icons.access_time,
//                             text: 'Stories\n(5)',
//                           ),
//                         ],
//                       ),
//
//                       const SizedBox(height: 8),
//
//                       const Row(
//                         children: [
//                           InfoCard(
//                             icon: Icons.home_work,
//                             text: 'Reviews\n(231)',
//                           ),
//                           SizedBox(width: 8),
//                           InfoCard(
//                             icon: Icons.school,
//                             text: 'Experience\n10+ years',
//                           ),
//                         ],
//                       ),
//
//                       SizedBox(height: 25),
//
//                       Divider(),
//
//                       SizedBox(height: 25),
//
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               Icon(CupertinoIcons.location_solid),
//                               SizedBox(width: 10),
//                               Text(
//                                 'Kollupitiya, Colombo',
//                                 style: TextStyles.captions,
//                               ),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               Icon(CupertinoIcons.star_fill,color: Colors.amber,),
//                               SizedBox(width: 10),
//                               Text(
//                                 '5.0',
//                                 style: TextStyles.captions,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 32),
//
//                        Text(
//                         "About Me -",
//                         style: TextStyles.headlineLarge,
//                       ),
//
//                       const SizedBox(height: 16),
//
//                        Text(
//                         'I\'m Sam, an experienced electrician and plumber based in Colombo. \n\n'
//                             'With a knack for troubleshooting and a commitment to quality, I bring a blend of skills to every project.\n\n'
//                             'I pride myself on my attention to detail and strive to minimize disruption to your day. '
//                             'Whether it\'s installing new systems or fixing old ones, I approach each task with care. \n\n'
//                             'Outside of work, I enjoy giving back to the community, '
//                             'reflecting my dedication to hard work and integrity. For reliable services in Colombo, reach out to me today.',
//                         style: TextStyles.bodyMedium,
//                       ),
//
//                       SizedBox(height: 50),
//
//                       Row(
//                         children: [
//                           SizedBox(width: 16),
//                           Expanded(
//                             child: Material(
//                               elevation: 5,
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(100),
//                               ),
//                               child: Container(
//                                 height: 60,
//                                 decoration: BoxDecoration(
//                                   color: TextStyles.primaryColor,
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(100),
//                                   ),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     "Book Now",
//                                     style: TextStyles.customTextStyle,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class InfoCard extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   //basically a constructor to intialize them
//   const InfoCard({required this.icon, required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.all(10),
//         margin: EdgeInsets.all(7),
//         decoration: BoxDecoration(
//           color: TextStyles.primaryColor.withOpacity(0.14),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           children: [
//             Icon(
//               icon,
//               size: 30,
//             ),
//             SizedBox(height: 8),
//             Text(
//               text,
//               textAlign: TextAlign.center,
//               style: TextStyles.labelLarge,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }