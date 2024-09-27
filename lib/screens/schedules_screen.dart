import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/models/schedule.dart';
import 'package:netvexanh_mobile/screens/rating_screen.dart';
import 'package:netvexanh_mobile/services/schedule_service.dart';
import 'package:netvexanh_mobile/screens/app_theme.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatelessWidget {
  ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Lịch Chấm', style: _titleStyle),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<Schedule>>(
        future: ScheduleService.getSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _MessageDisplay(
                message: 'Failed to load schedules: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _MessageDisplay(message: 'Trống');
          } else {
            return _ScheduleList(schedules: snapshot.data!);
          }
        },
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  final List<Schedule> schedules;

  const _ScheduleList({Key? key, required this.schedules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: schedules.length,
      itemBuilder: (context, index) => _ScheduleListItem(
        schedule: schedules[index],
        index: index,
      ),
    );
  }
}

class _ScheduleListItem extends StatelessWidget {
  final Schedule schedule;
  final int index;

  const _ScheduleListItem(
      {Key? key, required this.schedule, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isRating = schedule.status == 'Rating';

    return GestureDetector(
      onTap: isRating
          ? () => _navigateToScheduleAwardScreen(context, schedule.id)
          : null,
      child: Opacity(
        opacity:
            isRating ? 1.0 : 0.5, // Reduce opacity for non-selectable items
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: _itemDecoration,
          child: ListTile(
            title: Text('${schedule.contestName} - ${schedule.round} ',
                style: _textStyle),
            subtitle: Text(
              'Ngày chấm: ${formattedEndDate(schedule.endDate)}',
              style: _textStyle.copyWith(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

String formattedEndDate(DateTime? endDate) {
  if (endDate == null) {
    return 'No End Date';
  } else {
    return DateFormat('dd/MM/yyyy').format(endDate);
  }
}

}

class _MessageDisplay extends StatelessWidget {
  final String message;

  const _MessageDisplay({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message, style: _textStyle));
  }
}

void _navigateToScheduleAwardScreen(BuildContext context, String id) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => RatingScreen(scheduleId: id)));
}

// Common styles
final TextStyle _titleStyle = TextStyle(
  fontFamily: "Roboto",
  fontSize: 24,
  fontWeight: FontWeight.w500,
  color: AppTheme.nearlyBlack,
);

final TextStyle _textStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 16,
  color: AppTheme.nearlyBlack,
);

final BoxDecoration _itemDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(8),
  boxShadow: const [
    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
  ],
);
