import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/models/schedule_award.dart';
import 'package:netvexanh_mobile/screens/app_theme.dart';
import 'package:netvexanh_mobile/services/schedule_award_service.dart';
import 'rating_screen.dart';

class ScheduleAwardScreen extends StatelessWidget {
  final List<ScheduleAward> scheduleAwards;

  const ScheduleAwardScreen({Key? key, required this.scheduleAwards})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Scaffold(
      backgroundColor: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
      appBar: AppBar(
        title: Text(
          'Danh Sách Bài Thi',
          style: TextStyle(
            fontSize: 24,
            color: isLightMode ? AppTheme.darkText : AppTheme.white,
          ),
        ),
        backgroundColor: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
      ),
      body: ListView.builder(
        itemCount: scheduleAwards.length,
        itemBuilder: (context, index) {
          final award = scheduleAwards[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
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
              leading: CircleAvatar(
                child: _getRankIcon(award),
              ),
              title: _getRank(award),
              onTap: () => _loadScheduleDetailsAndNavigate(context, award.id),
            ),
          );
        },
      ),
    );
  }

  Widget _getRankIcon(ScheduleAward award) {
    if (award.rank == 'FirstPrize') {
      return Image.asset('assets/images/1.png');
    } else if (award.rank == 'SecondPrize') {
      return Image.asset('assets/images/2.png');
    } else if (award.rank == 'ThirdPrize') {
      return Image.asset('assets/images/3.png');
    } else if (award.rank == 'ConsolationPrize') {
      return Image.asset('assets/images/4.png');
    } else {
      return Image.asset('assets/images/0.png');
    }
  }

  Widget _getRank(ScheduleAward award) {
    if (award.rank == 'FirstPrize') {
      return Text('Giải Nhất');
    } else if (award.rank == 'SecondPrize') {
      return Text('Giải Nhì');
    } else if (award.rank == 'ThirdPrize') {
      return Text('Giải Ba');
    } else if (award.rank == 'ConsolationPrize') {
      return Text('Giải Khuyến Khích');
    } else {
      return Text('Vòng Loại');
    }
  }

  void _loadScheduleDetailsAndNavigate(BuildContext context, String id) {
    ScheduleAwardService.getScheduleAwardById(id).then((scheduleAward) {
      // Navigate to RatingScreen and pass data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RatingScreen(
            scheduleAward: scheduleAward,
          ),
        ),
      );
    }).catchError((error) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load schedule details: $error'),
        ),
      );
    });
  }
}
