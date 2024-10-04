import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/ratingsandreviews_model.dart';
import '../../models/sp-detailed.dart';  // Import the detailed model
import '../../services/location_service.dart';
import '../../services/service-provider-service.dart';  // Import the service
import '../widgets/styles.dart';
import 'booknow.dart';  // Import your custom styles
import 'package:share_plus/share_plus.dart';


class DetailedJobCard extends StatefulWidget {
  final int serviceProviderId;
  final String serviceType;

  const DetailedJobCard({Key? key, required this.serviceProviderId, required this.serviceType}) : super(key: key);

  @override
  _DetailedJobCardState createState() => _DetailedJobCardState();
}

class _DetailedJobCardState extends State<DetailedJobCard> {
  ServiceProviderDetail? providerDetail;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchServiceProviderDetails();
  }

  Future<void> fetchServiceProviderDetails() async {
    final service = CategoryServiceProviderService();

    try {
      Position? position = await LocationService().getLocationFromStorage();

      if (position != null) {
        final fetchedProvider = await service.getServiceProviderDetails(
          widget.serviceProviderId,
          position.latitude,
          position.longitude,
        );

        setState(() {
          providerDetail = fetchedProvider;
          isLoading = false;
        });
      } else {
        throw Exception('Location not found.');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void _shareServiceProviderInfo() {
    if (providerDetail == null) {
      return;  // Ensure the provider details are available before sharing
    }

    // Generate the URL for the service provider, assuming you have a web or deep link structure
    final String providerLink = 'http://127.0.0.1:8000/api/service-provider/${providerDetail!.id}';
    // final String providerLink = 'http://127.0.0.1:8000/api/service-provider/${providerDetail!.id}/?latitude=$latitude&longitude=$longitude';

    // 1?latitude=37.4219983&longitude=122.084/
    // Update the share message to be more professional and business-oriented
    final String shareText = '🚀 Check out this FixItPro! 🚀\n\n'
        '👤 Name: ${providerDetail!.firstName} ${providerDetail!.lastName}\n'
        '🔧 Service Type: ${widget.serviceType}\n'
        '📍 Location: ${providerDetail!.city}\n'
        '\nView the full profile and book services directly by clicking the link below:\n'
        '$providerLink\n\n'
        '🔗 Powered by FixItNow – Your Trusted Service Provider Platform';

    // Trigger the sharing functionality
    Share.share(shareText);
  }


  // Function to show the full-screen modal with reviews
  void _showReviewsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,  // Ensure a solid background color
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,  // 90% height of the screen
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ratings & Reviews',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();  // Close the modal
                    },
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: providerDetail!.ratingsAndReviews == null ||
                    providerDetail!.ratingsAndReviews!.isEmpty
                    ? const Center(child: Text('No reviews available'))
                    : ListView.builder(
                  itemCount: providerDetail!.ratingsAndReviews!.length,
                  itemBuilder: (context, index) {
                    final review = providerDetail!.ratingsAndReviews![index];
                    return _buildReviewCard(review);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper widget to build each review card with improved styling
  Widget _buildReviewCard(RatingsAndReviewsModel review) {
    return Card(
      elevation: 3,  // Add elevation for a subtle shadow effect
      margin: const EdgeInsets.symmetric(vertical: 10),  // Add margin between cards
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),  // Rounded corners for the cards
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),  // Increased padding inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  CupertinoIcons.star_fill,
                  color: Colors.amber,
                  size: 24,
                ),
                const SizedBox(width: 8),  // Spacing between star icon and text
                Text(
                  'Rating: ${review.rating}/5',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),  // Space between rating and review text
            Text(
              review.review,  // Display the review text
              style: TextStyles.bodyMedium.copyWith(fontSize: 14),  // Use body text style
            ),
            const SizedBox(height: 8),  // Space between review text and date
            Text(
              'Date: ${review.createdAt}',
              style: TextStyles.captions.copyWith(color: Colors.grey[600]),  // Subtle text color for the date
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextStyles.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Worker Profile',
          style: TextStyles.titleLarge,
        ),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.share_outlined, size: 24, color: Colors.black),
                onPressed: _shareServiceProviderInfo,  // Call the share function here
              ),
              const SizedBox(width: 14),
              const Icon(Icons.bookmark_border, size: 24, color: Colors.black),
              const SizedBox(width: 14),
              const Icon(Icons.more_vert_rounded, size: 24, color: Colors.black),
              const SizedBox(width: 16),
            ],
          ),
        ],

      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
          ? const Center(child: Text('Error loading provider details'))
          : providerDetail == null
          ? const Center(child: Text('No provider details available'))
          : SingleChildScrollView(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display profile image or placeholder
                  Center(
                    child: Hero(
                      tag: 'image-transition',
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: providerDetail!.profileImage != null
                            ? NetworkImage(providerDetail!.profileImage!)
                            : const AssetImage('assets/placeholder.png') as ImageProvider,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      '${providerDetail!.firstName} ${providerDetail!.lastName}',
                      style: TextStyles.headlineLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      InfoCard(
                        icon: Icons.location_on,
                        text: 'Distance\n${providerDetail!.distance ?? 'Unknown'} away',
                      ),
                      const SizedBox(width: 8),
                      InfoCard(
                        icon: Icons.timer,
                        text: 'Est. Delivery Time\n${providerDetail!.estimatedTime ?? 'Unknown'}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      InfoCard(
                        icon: Icons.home_work,
                        text: 'Reviews\n(231)',
                      ),
                      const SizedBox(width: 8),
                      InfoCard(
                        icon: Icons.school,
                        text: 'Experience\n${providerDetail!.yearsOfExperience} year/s',
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    height: 2,  // Thin and elegant
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),  // Rounded ends for smoothness
                      gradient: const LinearGradient(
                        colors: [Colors.grey, Colors.black54],  // Subtle gradient for a touch of luxury
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(CupertinoIcons.location_solid),
                          const SizedBox(width: 10),
                          Text(
                            providerDetail!.city,
                            style: TextStyles.captions,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.star_fill, color: Colors.amber),
                          const SizedBox(width: 10),
                          Text(
                            '5.0', // Example rating
                            style: TextStyles.captions,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "About Me -",
                    style: TextStyles.headlineLarge,
                  ),
                  const SizedBox(height: 16),

                  Text(
                    providerDetail!.description,
                    style: TextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],  // Light background to make the text stand out
                      borderRadius: BorderRadius.circular(12),  // Rounded edges for clean look
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First Line: Heads up!
                        Center(
                          child: Row(
                            children: [

                              const SizedBox(width: 8),
                              Flexible(
                                child: Center(
                                  child: Text(
                                    "Heads up!",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: TextStyles.primaryColor,  // Use primary color for "Heads up!"
                                      fontSize: 18,  // Slightly larger font
                                    ),
                                    overflow: TextOverflow.ellipsis,  // Handle overflow gracefully
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),  // Space between lines

                        // Second Line: Distance (Highlighted using primary color)
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.location_solid,  // Location icon
                              color: Colors.black87,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Your FixItNow Pro is about ",
                                      style: TextStyle(
                                          color: Colors.black
                                      ),  // Normal text style
                                    ),
                                    TextSpan(
                                      text: "${providerDetail?.distance} ",  // Emphasize distance
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: TextStyles.primaryColor,  // Highlight with primary color
                                      ),
                                    ),
                                    TextSpan(
                                      text: " away.",
                                      style: TextStyle(
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,  // Handle text overflow
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),  // Space between lines

                        // Third Line: Estimated Time (Highlighted using primary color)
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,  // Time icon
                              color: Colors.black87,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "It'll take approximately  ",
                                      style: TextStyle(
                                          color: Colors.black
                                      ),
                                    ),
                                    TextSpan(
                                      text: "${providerDetail?.estimatedTime} ",  // Emphasize time
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: TextStyles.primaryColor,  // Highlight with primary color
                                      ),
                                    ),
                                    TextSpan(
                                      text: " to reach you!",
                                      style: TextStyle(
                                          color: Colors.black
                                      ),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,  // Handle text overflow
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),  // Space between lines




                  Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: providerDetail!.availability
                              ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppointmentForm(
                                  serviceProviderId: providerDetail!.id,
                                  serviceType: widget.serviceType,
                                  serviceProviderName: providerDetail!.firstName,
                                ),
                              ),
                            );
                          }
                              : null,
                          child: Material(
                            elevation: 5,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: providerDetail!.availability
                                    ? TextStyles.primaryColor
                                    : Colors.grey,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  providerDetail!.availability
                                      ? "Book Now"
                                      : "Not Available",
                                  style: TextStyles.customTextStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Floating Action Button to show reviews
      floatingActionButton: FloatingActionButton(
        backgroundColor: TextStyles.primaryColor,
        onPressed: _showReviewsModal,
        child: const Icon(CupertinoIcons.star_fill),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: TextStyles.primaryColor.withOpacity(0.14),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyles.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
