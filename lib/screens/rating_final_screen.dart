// import 'package:flutter/material.dart';
// import 'package:netvexanh_mobile/models/painting.dart';
// import 'package:netvexanh_mobile/models/painting_result.dart';
// import 'package:netvexanh_mobile/models/schedule_award.dart';
// import 'package:netvexanh_mobile/screens/schedule_awards_screen.dart';
// import 'package:netvexanh_mobile/services/painting_service.dart';
// import 'package:netvexanh_mobile/services/schedule_award_service.dart';
// import 'package:netvexanh_mobile/services/schedule_service.dart';

// class RatingFinalScreen extends StatefulWidget {
//   final String awardId;

//   const RatingFinalScreen({super.key, required this.awardId});

//   @override
//   // ignore: library_private_types_in_public_api
//   _RatingScreenState createState() => _RatingScreenState();
// }

// class _RatingScreenState extends State<RatingFinalScreen>
//     with TickerProviderStateMixin {
//   late ScheduleAward _scheduleAward;
//   late List<Painting> _paintings;
//   late List<Painting> _filteredPaintings;
//   late int _currentIndex;
//   bool _isLoading = true;
//   bool _isSearching = false;
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = 0;
//     _fetchPaintings();
//     _clearMemory();
//   }

//   void _clearMemory() {
//     PaintingService.clearPaintingResults();
//   }

//   Future<void> _fetchPaintings() async {
//     try {
//       _scheduleAward =
//           await ScheduleAwardService.getScheduleAwardById(widget.awardId);
//       setState(() {
//         _paintings = _scheduleAward.paintingViewModelsList;
//         _filteredPaintings = List.from(_paintings); // Initialize filtered list
//         _isLoading = false;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load paintings: $e')),
//       );
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _showDetailPopup(int index) {
//     _currentIndex = index;
//     _displayPopup(_currentIndex);
//   }

//   void _displayPopup(int index) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return GestureDetector(
//           onHorizontalDragEnd: (details) {
//             if (details.primaryVelocity! < 0) {
//               if (index < _filteredPaintings.length - 1) {
//                 Navigator.of(context).pop();
//                 _showDetailPopup(index + 1);
//               }
//             } else if (details.primaryVelocity! > 0) {
//               if (index > 0) {
//                 Navigator.of(context).pop();
//                 _showDetailPopup(index - 1);
//               }
//             }
//           },
//           child: AlertDialog(
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   _filteredPaintings[index].code ?? 'Painting Detail',
//                   style: const TextStyle(fontSize: 15),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.of(context).pop(),
//                 )
//               ],
//             ),
//             content: SizedBox(
//               height: 400,
//               width: 300,
//               child: Column(
//                 children: [
//                   if (_filteredPaintings[index].image != null)
//                     Image.network(
//                       _filteredPaintings[index].image!,
//                       fit: BoxFit.cover,
//                       height: 200,
//                       width: double.infinity,
//                     ),
//                   const SizedBox(height: 16),
//                   Text(
//                     _filteredPaintings[index].description ?? 'No Description',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           _showConfirmationDialog(index, true);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           backgroundColor: Colors.green,
//                         ),
//                         child: const Text('Đạt'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           _showConfirmationDialog(index, false);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           backgroundColor: Colors.red,
//                         ),
//                         child: const Text('Không Đạt'),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _showConfirmationDialog(int index, bool isPass) {
//     String reason = '';
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(isPass ? 'Xác Nhận Đạt' : 'Xác Nhận Không Đạt'),
//           content: isPass
//               ? const Text('Bạn có chắc chắn muốn đánh dấu tranh này là "Đạt"?')
//               : Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                         'Bạn có chắc chắn muốn đánh dấu tranh này là "Không Đạt"?'),
//                     const SizedBox(height: 8),
//                     TextField(
//                       maxLines: 3,
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: 'Nhập lý do...',
//                       ),
//                       onChanged: (value) {
//                         reason = value.toString();
//                       },
//                     ),
//                   ],
//                 ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Hủy'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//                 _updatePaintingStatus(index, isPass, reason);
//               },
//               child: const Text('Xác Nhận'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _updatePaintingStatus(int index, bool isPass, String reason) async {
//     final updatedPainting = _filteredPaintings[index].copyWith(
//       borderColor: isPass ? Colors.green : Colors.red,
//     );

//     setState(() {
//       // Cập nhật trong danh sách đã lọc
//       _filteredPaintings[index] = updatedPainting;

//       // Tìm và cập nhật trong danh sách gốc
//       int originalIndex =
//           _paintings.indexWhere((p) => p.id == updatedPainting.id);
//       if (originalIndex != -1) {
//         _paintings[originalIndex] = updatedPainting;
//       }
//     });

//     await PaintingService.savePaintingResult(
//       PaintingResult(
//         updatedPainting.id,
//         updatedPainting.code,
//         isPass,
//         reason,
//       ),
//     );

//     if (index < _filteredPaintings.length - 1) {
//       _showDetailPopup(index + 1);
//     }
//   }

//   void _searchPaintings(String query) {
//     setState(() {
//       _filteredPaintings = _paintings
//           .where((painting) =>
//               painting.code!.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   void _resetSearch() {
//     setState(() {
//       _filteredPaintings =
//           List.from(_paintings); // Tạo một bản sao mới từ _paintings
//       _isSearching = false;
//       _searchController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Rating Screen'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.list),
//             onPressed: () async {
//               final results = await PaintingService.getPaintingResults();
//               _showResultsPopup(results);
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               setState(() {
//                 _isSearching = true;
//               });
//             },
//           ),
//           if (_isSearching)
//             IconButton(
//               icon: const Icon(Icons.clear),
//               onPressed: () {
//                 _resetSearch();
//               },
//             ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 if (_isSearching)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       controller: _searchController,
//                       decoration: const InputDecoration(
//                         labelText: 'Tìm kiếm theo mã tranh',
//                         border: OutlineInputBorder(),
//                       ),
//                       onChanged: _searchPaintings,
//                     ),
//                   ),
//                 Expanded(
//                   child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                     ),
//                     itemCount: _filteredPaintings.length,
//                     itemBuilder: (context, index) {
//                       final painting = _filteredPaintings[index];
//                       return GestureDetector(
//                         onTap: () => _showDetailPopup(index),
//                         child: Card(
//                           elevation: 4,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: painting.borderColor ??
//                                           Colors.transparent,
//                                       width: 5,
//                                     ),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: painting.image != null
//                                       ? Image.network(
//                                           painting.image!,
//                                           fit: BoxFit.cover,
//                                         )
//                                       : const Center(child: Text('No Image')),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   painting.code ?? 'Untitled',
//                                   textAlign: TextAlign.center,
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }

//   void _showResultsPopup(List<PaintingResult> results) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Saved Results'),
//               IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//             ],
//           ),
//           content: SizedBox(
//             height: 400,
//             width: 300,
//             child: Column(
//               children: [
//                 Expanded(
//                     child: ListView.builder(
//                   padding:
//                       const EdgeInsets.all(16.0), // Padding around the ListView
//                   itemCount: results.length,
//                   itemBuilder: (context, index) {
//                     final result = results[index];
//                     return Card(
//                       elevation: 4.0, // Shadow depth for the card
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 8.0), // Margin between cards
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.all(
//                             16.0), // Padding inside each ListTile
//                         title: Text(
//                           'Mã Tranh: ${result.code}',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16.0,
//                           ),
//                         ),
//                         subtitle: Text(
//                           result.isPass ? 'Đạt' : 'Không Đạt',
//                           style: TextStyle(
//                             color: result.isPass ? Colors.green : Colors.red,
//                             fontSize: 14.0,
//                           ),
//                         ),
//                         leading: Icon(
//                           result.isPass ? Icons.check_circle : Icons.cancel,
//                           color: result.isPass ? Colors.green : Colors.red,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                       ),
//                     );
//                   },
//                 )),
//                 ElevatedButton(
//                   onPressed: () async {
//                     bool canProceed =
//                         await _checkConditionsAndShowWarnings(results);
//                     if (canProceed) {
//                       // Tiến hành gửi kết quả
//                       String scheduleId = _scheduleAward.scheduleId.toString();
//                       String awardId = _scheduleAward.awardId.toString();

//                       bool success = await ScheduleService()
//                           .RatingPreliminaryRound(scheduleId, awardId, results);

//                       // Hiển thị AlertDialog thay vì SnackBar
//                       await showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: Text(success ? 'Thành Công' : 'Thất Bại'),
//                             content: Text(
//                               success
//                                   ? 'Chấm Bài Thành Công'
//                                   : 'Gửi kết quả thất bại',
//                             ),
//                             actions: <Widget>[
//                               TextButton(
//                                 child: const Text('OK'),
//                                 onPressed: () {
//                                   Navigator.of(context)
//                                       .pop(); // Đóng AlertDialog
//                                   if (success) {
//                                     Navigator.of(context)
//                                         .pop();
//                                     _clearMemory();
//                                     _navigateToScheduleAwardScreen(_scheduleAward.scheduleId!);
//                                   }
//                                 },
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                     }
//                   },
//                   child: const Text('Send Results'),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Future<bool> _checkConditionsAndShowWarnings(
//       List<PaintingResult> results) async {
//     if (results.length != _paintings.length) {
//       await _showWarningDialog('Vui Lòng Chấm Điểm Cho Tất Cả Bức Tranh');
//       return false;
//     }

//     int numPass = results.where((result) => result.isPass == true).length;
//     if (numPass != _scheduleAward.quantity) {
//       await _showWarningDialog(
//           'Số Lượng Tranh Đạt Chưa Đủ Bạn Cần ${_scheduleAward.quantity}, Hiện Đang Có ${numPass} Bài Thi Đạt');
//       return false;
//     }

//     return true;
//   }

//   Future<void> _showWarningDialog(String message) async {
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Cảnh Báo'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _navigateToScheduleAwardScreen(String id) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ScheduleAwardScreen(scheduleId: id),
//       ),
//     );
//   }
// }
