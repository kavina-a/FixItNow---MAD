import 'package:fixitnow/screens/categories/service_provider_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fixitnow/screens/widgets/styles.dart';
import 'package:fixitnow/screens/login&signup/login.dart';

import '../../../services/customer-service.dart';

class JobCard extends StatefulWidget {
  const JobCard({super.key});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  List<dynamic> topWorkers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTopWorkers();
  }

  // Function to fetch top workers from the backend
  Future<void> _fetchTopWorkers() async {
    try {
      final workers = await CustomerService().getTopWorkers();
      setState(() {
        topWorkers = workers;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching top workers: $error");
      setState(() {
        isLoading = false; // Stop loading even if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size; // Gets screen size

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "This Week's Top Workers",
          style: TextStyles.titleLarge,
        ),
        SizedBox(height: size.height * 0.04),

        isLoading
            ? Center(child: CircularProgressIndicator()) // Loading indicator
            : topWorkers.isEmpty
            ? Center(child: Text('No top workers found.')) // No workers message
            : Column(
          children: topWorkers
              .map((worker) => buildWorkerCard(worker, context))
              .toList(),
        ),
      ],
    );
  }

  // Build Worker Card Widget
  Widget buildWorkerCard(dynamic worker, BuildContext context) {
    String? imageUrl = worker['service_provider_profile_image'];

    // Check if the image URL is not empty and prepend base URL if necessary
    if (imageUrl != null && !imageUrl.startsWith('http') &&
        !imageUrl.startsWith('https')) {
      imageUrl =
      "http://10.0.2.2:8000/api/$imageUrl"; // Prepend your actual domain/base URL here
    }

    // Parse service types
    List<String> serviceTypes = [];
    if (worker['service_provider_service_type'] != null) {
      // Assuming the service types are stored as a JSON-encoded string like '["Plumber","Mason"]'
      serviceTypes =
          (worker['service_provider_service_type'] as String).replaceAll(
              '[', '').replaceAll(']', '').replaceAll('"', '').split(', ');
    }

    // Get the service provider id
    int serviceProviderId = worker['serviceprovider_id'];

    // Get the first service type, if available
    String firstServiceType = serviceTypes.isNotEmpty ? serviceTypes[0] : 'No service type';
    int completedAppointments = worker['completed_appointments'] ?? 0;


    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>
              DetailedJobCard(serviceProviderId: serviceProviderId, serviceType: firstServiceType)), // Example of a page transition
        );
      },
      child: Material(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: double.maxFinite,
          height: 170,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: TextStyles.primaryColor.withOpacity(0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white38.withOpacity(0.1),
                        backgroundImage: imageUrl != null
                            ? NetworkImage(
                            imageUrl) // Profile image fetched from the service
                            : AssetImage(
                            'asset/placeholder.png') as ImageProvider,
                        // Fallback to placeholder image
                        onBackgroundImageError: (error, stackTrace) {
                          print('Error loading image: $error');
                        },
                      ),
                      SizedBox(width: 10),

                      // Worker's Name and Tags
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            worker['service_provider_name'] ?? 'Unknown',
                            // Worker's name with fallback
                            style: TextStyles.bodyLarge,
                          ),
                          SizedBox(height: 5),

                          // Display service types as individual containers
                          Wrap(
                            spacing: 8.0, // Spacing between items
                            children: serviceTypes.map((serviceType) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  serviceType, // Display each service type
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    CupertinoIcons.bookmark_fill,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                    size: 30,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.location_solid,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .tertiary,
                      ),
                      SizedBox(width: 5),
                      Text(
                        worker['service_provider_city'] ?? 'Unknown City',
                        // Worker's city with fallback
                        style: TextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.hand_thumbsup_fill, // Example icon for trust/reliability
                        color: Theme
                            .of(context)
                            .colorScheme
                            .tertiary,
                      ),
                      SizedBox(width: 5),

                      Text(
                        '$completedAppointments done/week' ,
                        // Example static rating, replace with dynamic if available
                        style: TextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}