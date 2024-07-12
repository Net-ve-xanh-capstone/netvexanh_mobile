import 'dart:async';
import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/models/schedule.dart';
import 'package:netvexanh_mobile/screens/app_theme.dart';
import 'package:netvexanh_mobile/screens/schedule_awards_screen.dart';
import 'package:netvexanh_mobile/services/schedule_service.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with TickerProviderStateMixin {
  late Future<List<Schedule>> list;

  @override
  void initState() {
    super.initState();
    list = ScheduleService.getSchedules();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Scaffold(
      backgroundColor: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
      appBar: AppBar(
        title: Text(
          'Schedule List',
          style: TextStyle(
            fontSize: 24,
            color: isLightMode ? AppTheme.darkText : AppTheme.white,
          ),
        ),
        backgroundColor: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
      ),
      body: FutureBuilder<List<Schedule>>(
        future: list,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load schedules'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No schedules found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final schedule = snapshot.data![index];
                bool canSelect =
                    schedule.status == 'ratting';
                Color tileColor =
                    canSelect ? Colors.white : Colors.grey.withOpacity(0.5);

                return GestureDetector(
                  onTap: () {
                    if (canSelect) {
                      _navigateToScheduleAwardScreen(schedule
                          .id); // Gọi hàm để load chi tiết lịch trình và chuyển màn hình
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: tileColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${index + 1}')),
                      title: Text(schedule.id),
                      subtitle: Text(schedule.description ?? 'No Description'),
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

  // Hàm gọi để chuyển sang màn hình mới với ID của lịch trình
  void _navigateToScheduleAwardScreen(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ScheduleAwardScreen(scheduleId: id), // Truyền ID vào màn hình mới
      ),
    );
  }
}
