import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../models/sp-analytics.model.dart';
import '../../../../services/service-provider-service.dart';

class SP_AnalyticsPage extends StatefulWidget {
  @override
  _SP_AnalyticsPageState createState() => _SP_AnalyticsPageState();
}

class _SP_AnalyticsPageState extends State<SP_AnalyticsPage> {
  late Future<AnalyticsModel> _analytics;

  @override
  void initState() {
    super.initState();
    _analytics = CategoryServiceProviderService().getServiceProviderAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate 50% of the screen height
    double halfScreenHeight = MediaQuery.of(context).size.height * 0.4;

    return FutureBuilder<AnalyticsModel>(
      future: _analytics,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No analytics data available'));
        } else {
          final analytics = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  height: halfScreenHeight,
                  child: Column(
                    children: [
                      // Header
                      Text(
                        'Appointments Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white // White in dark mode
                              : Colors.black87, // Black in light mode
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),

                      // Pie Chart
                      Expanded(
                        child: Center(
                          child: SizedBox(
                            height: 160,
                            width: 160,
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    color: Colors.green,
                                    value: analytics.completedAppointments.toDouble(),
                                    title: 'Completed',
                                    radius: 50,
                                    titleStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.white // White in dark mode
                                          : Colors.black87, // Black in light mode
                                    ),

                                  ),
                                  PieChartSectionData(
                                    color: Colors.red,
                                    value: analytics.rejectedAppointments.toDouble(),
                                    title: 'Rejected',
                                    radius: 50,
                                    titleStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Stats boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AnalyticsBox(
                              title: 'Completed',
                              value: analytics.completedAppointments.toString(),
                              color: Colors.greenAccent,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: AnalyticsBox(
                              title: 'Rejected',
                              value: analytics.rejectedAppointments.toString(),
                              color: Colors.redAccent,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: AnalyticsBox(
                              title: 'Reviews',
                              value: analytics.totalReviews.toString(),
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

// Analytics Box widget
class AnalyticsBox extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const AnalyticsBox({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
              ),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white // White in dark mode
                    : Colors.black87, // Black in light mode
              ),
            ),

          ],
        ),
      ),
    );
  }
}
