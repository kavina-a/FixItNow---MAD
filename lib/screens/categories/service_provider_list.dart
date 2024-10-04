import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/sp_category-list.dart';
import '../../services/service-provider-service.dart';
import '../../services/location_service.dart';
import '../widgets/styles.dart';
import 'service_provider_detail.dart'; // Make sure this import is correct

class ServiceProviderList extends StatefulWidget {
  final String category;

  ServiceProviderList({required this.category});

  @override
  _ServiceProviderListState createState() => _ServiceProviderListState();
}

class _ServiceProviderListState extends State<ServiceProviderList> {
  List<CategoryServiceProviderList> providers = [];
  List<CategoryServiceProviderList> originalProviders = []; // To store original order
  bool isLoading = true;
  bool hasError = false;
  Position? userPosition;
  bool isSorted = false; // Track whether providers are sorted

  @override
  void initState() {
    super.initState();
    fetchUserLocationAndServiceProviders();
  }

  Future<void> fetchUserLocationAndServiceProviders() async {
    final service = CategoryServiceProviderService();

    try {
      userPosition = await LocationService().getLocationFromStorage();

      if (userPosition != null) {
        final fetchedProviders = await service.getServiceProviders(
          widget.category,
          userPosition!.latitude,
          userPosition!.longitude,
        );
        setState(() {
          providers = fetchedProviders;
          originalProviders = List.from(fetchedProviders); // Store original order
          isLoading = false;
        });
      } else {
        throw Exception('Failed to retrieve user location');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void _toggleSort() {
    setState(() {
      if (isSorted) {
        // Revert back to the original order
        providers = List.from(originalProviders);
      } else {
        // Sort by estimated time
        providers.sort((a, b) {
          int timeA = _convertTimeToMinutes(a.estimatedTime);
          int timeB = _convertTimeToMinutes(b.estimatedTime);
          return timeA.compareTo(timeB);
        });
      }
      isSorted = !isSorted; // Toggle the sorting state
    });
  }

  int _convertTimeToMinutes(String estimatedTime) {
    final RegExp hourRegExp = RegExp(r'(\d+)\s*hours?');  // Matches hours
    final RegExp minuteRegExp = RegExp(r'(\d+)\s*mins?');  // Matches minutes

    int totalMinutes = 0;

    // Check for hours
    final hourMatch = hourRegExp.firstMatch(estimatedTime);
    if (hourMatch != null) {
      final hours = int.parse(hourMatch.group(1)!);
      totalMinutes += hours * 60;  // Convert hours to minutes
    }

    // Check for minutes
    final minuteMatch = minuteRegExp.firstMatch(estimatedTime);
    if (minuteMatch != null) {
      final minutes = int.parse(minuteMatch.group(1)!);
      totalMinutes += minutes;  // Add minutes
    }

    return totalMinutes;  // Return the total in minutes
  }

  String _convertMinutesToConciseFormat(int totalMinutes) {
    final hours = totalMinutes ~/ 60; // Integer division to get hours
    final minutes = totalMinutes % 60; // Remainder to get minutes

    String result = '';
    if (hours > 0) {
      result += '$hours ${hours > 1 ? 'hours' : 'hour'}';
    }
    if (minutes > 0) {
      result += (result.isNotEmpty ? ' ' : '') + '$minutes ${minutes > 1 ? 'mins' : 'min'}';
    }
    return result.isEmpty ? '0 mins' : result; // Default to '0 mins' if nothing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Service Providers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _toggleSort, // Call the toggle sort function
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
          ? const Center(child: Text('Error loading providers'))
          : ListView.builder(
        itemCount: providers.length,
        itemBuilder: (context, index) {
          final provider = providers[index];

          // Directly use the list of service types
          List<String> serviceTypes = provider.serviceType ?? ['No service type'];

          String firstServiceType = serviceTypes.isNotEmpty
              ? serviceTypes[0]
              : 'No service type';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailedJobCard(
                    serviceProviderId: provider.id,
                    serviceType: firstServiceType,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Material(
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: double.maxFinite,
                  height: 170,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: TextStyles.primaryColor.withOpacity(0.8),
                    boxShadow: const [
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
                              Hero(
                                tag: 'image-transition-$index',
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.white38.withOpacity(0.1),
                                  backgroundImage: provider.profileImage != null &&
                                      provider.profileImage!.isNotEmpty
                                      ? NetworkImage(provider.profileImage!)
                                      : AssetImage('assets/default_image.png') as ImageProvider,
                                  onBackgroundImageError: (error, stackTrace) {
                                    print('Error loading profile image: $error');
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${provider.firstName} ${provider.lastName}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  // Show the service types
                                  Wrap(
                                    spacing: 8.0,
                                    children: serviceTypes.map((serviceType) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                                          serviceType,
                                          style: const TextStyle(
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
                          const Icon(
                            CupertinoIcons.bookmark_fill,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Row(
                          //   children: [
                          //     Icon(
                          //       CupertinoIcons.location_solid,
                          //       color: Theme.of(context).colorScheme.tertiary,
                          //     ),
                          //     const SizedBox(width: 5),
                          //     Text(
                          //       provider. ?? 'Unknown City',
                          //       style: TextStyles.bodyMedium,
                          //     ),
                          //   ],
                          // ),
                          Row(
                            children: [
                              const Icon(
                                CupertinoIcons.time_solid,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${_convertMinutesToConciseFormat(_convertTimeToMinutes(provider.estimatedTime))} away!',
                                style: TextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
