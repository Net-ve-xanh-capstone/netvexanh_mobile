import 'dart:async';
import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/models/schedule.dart';
import 'package:netvexanh_mobile/screens/app_theme.dart';
import 'package:netvexanh_mobile/screens/rating_screen.dart';
import 'package:netvexanh_mobile/services/schedule_service.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with TickerProviderStateMixin {
  late Future<List<Schedule>> _schedulesFuture;

  @override
  void initState() {
    super.initState();
    _schedulesFuture = ScheduleService.getSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color set to white
      appBar: AppBar(
        title: Text(
          'Schedule List',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black, // Text color set to black for contrast
          ),
        ),
        backgroundColor: Colors.white, // AppBar background color set to white
        elevation: 0, // Removes the shadow from the AppBar
        iconTheme: IconThemeData(color: Colors.black), // Ensures icon color is black
      ),
      body: FutureBuilder<List<Schedule>>(
        future: _schedulesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load schedules: ${snapshot.error}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Error text color set to black
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No schedules found',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // No data text color set to black
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final schedule = snapshot.data![index];
                bool canSelect = schedule.status == 'Rating';
                Color tileColor = canSelect
                    ? Colors.white
                    : Colors.grey.shade300.withOpacity(0.5);

                return GestureDetector(
                  onTap: () {
                    if (canSelect) {
                      _navigateToScheduleAwardScreen(schedule.id);
                    }
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: tileColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text('Nét Vẽ Xanh ${schedule.year ?? '20XX'}'),
                      subtitle: Text(
                        '${schedule.round ?? 'No Description'} - ${schedule.endDate ?? 'No End Date'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _navigateToScheduleAwardScreen(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RatingScreen(scheduleId: id),
      ),
    );
  }
}
