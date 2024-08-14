// import 'package:flutter/material.dart';
// import 'package:netvexanh_mobile/models/schedule_award.dart';
// import 'package:netvexanh_mobile/screens/app_theme.dart';
// import 'package:netvexanh_mobile/services/schedule_service.dart';
// import 'rating_screen.dart';
// import 'navigation_home_screen.dart';

// class ScheduleAwardScreen extends StatelessWidget {
//   final String scheduleId;

//   const ScheduleAwardScreen({Key? key, required this.scheduleId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     var brightness = MediaQuery.of(context).platformBrightness;
//     bool isLightMode = brightness == Brightness.light;
//     return Scaffold(
//       backgroundColor: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
//       appBar: AppBar(
//         title: Text(
//           'Danh Sách Bài Thi',
//           style: TextStyle(
//             fontSize: 24,
//             color: isLightMode ? AppTheme.darkText : AppTheme.white,
//           ),
//         ),
//         backgroundColor: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: isLightMode ? AppTheme.darkText : AppTheme.white),
//           onPressed: () {
//             Navigator.of(context).popUntil((route) => route.isFirst);
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const NavigationHomeScreen(),
//               ),
//             );
//           },
//         ),
//       ),
//       body: FutureBuilder<List<ScheduleAward>>(
//         future: ScheduleService.getScheduleById(scheduleId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Failed to load schedule awards'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No schedule awards found'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final award = snapshot.data![index];
//                 bool canSelect = award.status == 'Rating';

//                 return GestureDetector(
//                   onTap: () {
//                     if (canSelect) {
//                       _navigateToRatingScreen(context, award.id);
//                     }
//                   },
//                   child: Container(
//                     margin: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: canSelect ? Colors.white : Colors.grey.withOpacity(0.5),
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 4,
//                           offset: Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: ListTile(
//                       leading: CircleAvatar(child: _getRankIcon(award)),
//                       title: _getRank(award),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   Widget _getRankIcon(ScheduleAward award) {
//     switch (award.rank) {
//       case 'FirstPrize':
//         return Image.asset('assets/images/1.png');
//       case 'SecondPrize':
//         return Image.asset('assets/images/2.png');
//       case 'ThirdPrize':
//         return Image.asset('assets/images/3.png');
//       case 'ConsolationPrize':
//         return Image.asset('assets/images/4.png');
//       default:
//         return Image.asset('assets/images/0.png');
//     }
//   }

//   Widget _getRank(ScheduleAward award) {
//     switch (award.rank) {
//       case 'FirstPrize':
//         return Text('Giải Nhất');
//       case 'SecondPrize':
//         return Text('Giải Nhì');
//       case 'ThirdPrize':
//         return Text('Giải Ba');
//       case 'ConsolationPrize':
//         return Text('Giải Khuyến Khích');
//       default:
//         return Text('Vòng Loại');
//     }
//   }

//   void _navigateToRatingScreen(BuildContext context, String id) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => RatingScreen(: id),
//       ),
//     );
//   }
// }
