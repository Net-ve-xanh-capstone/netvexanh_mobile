// import 'package:flutter/material.dart';
// import 'package:netvexanh_mobile/models/painting.dart';
// import 'package:netvexanh_mobile/models/painting_result.dart';
// import 'package:netvexanh_mobile/services/painting_service.dart';
// import 'package:photo_view/photo_view.dart';

// class PaintingDetailScreen extends StatefulWidget {
//   final List<Painting> paintings;
//   final int initialIndex;
//   final void Function(Painting updatedPainting) onPaintingStatusUpdated; // Add this parameter

//   const PaintingDetailScreen({
//     super.key,
//     required this.paintings,
//     required this.initialIndex,
//     required this.onPaintingStatusUpdated, // Initialize this parameter
//   });

//   @override
//   _PaintingDetailScreenState createState() => _PaintingDetailScreenState();
// }

// class _PaintingDetailScreenState extends State<PaintingDetailScreen> {
//   late PageController _pageController;
//   late int currentIndex;
//   bool _showReasonInput = false;
//   final TextEditingController _reasonController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     currentIndex = widget.initialIndex;
//     _pageController = PageController(initialPage: currentIndex);
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     _reasonController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var brightness = MediaQuery.of(context).platformBrightness;
//     bool isLightMode = brightness == Brightness.light;

//     return Scaffold(
//       backgroundColor: isLightMode ? Colors.white : Colors.black,
//       appBar: AppBar(
//         title: const Text('Chi Tiết Tranh'),
//         backgroundColor: isLightMode ? Colors.white : Colors.black,
//         iconTheme: IconThemeData(
//           color: isLightMode ? Colors.black : Colors.white,
//         ),
//       ),
//       body: PageView.builder(
//         controller: _pageController,
//         itemCount: widget.paintings.length,
//         onPageChanged: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//         itemBuilder: (context, index) {
//           final painting = widget.paintings[index];
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Container(
//                 padding: const EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   color: isLightMode
//                       ? const Color(0xFFF5F5F5)
//                       : const Color(0xFF1A1A1A),
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: const [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Row(
//                       children: [
//                         CircleAvatar(
//                           backgroundImage: AssetImage('assets/images/icon.png'),
//                           radius: 20,
//                         ),
//                         SizedBox(width: 8),
//                         Text(
//                           'Netvexanh',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     if (painting.image != null)
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => Scaffold(
//                                 appBar: AppBar(
//                                   backgroundColor: Colors.black,
//                                 ),
//                                 body: Center(
//                                   child: PhotoView(
//                                     imageProvider: NetworkImage(painting.image!),
//                                     backgroundDecoration: const BoxDecoration(
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           margin: const EdgeInsets.symmetric(horizontal: 5.0),
//                           child: Image.network(
//                             painting.image!,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     const SizedBox(height: 16),
//                     Text(
//                       painting.name ?? 'No Name',
//                       style: const TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       painting.description ?? 'No Description',
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Code: ${painting.code ?? 'Unknown'}',
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                     Text(
//                       'Chủ Đề: ${painting.roundTopicId ?? 'Unknown'}',
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                     Text(
//                       'Họ và tên: ${painting.ownerName ?? 'Unknown'}',
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                     Text(
//                       'Submit Time: ${painting.submitTime.toString()}',
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             _showConfirmationDialog(context, true);
//                           },
//                           child: const Text('Đạt'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green,
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               _showReasonInput = true;
//                             });
//                             _showConfirmationDialog(context, false);
//                           },
//                           child: const Text('Không Đạt'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red,
//                             foregroundColor: Colors.white,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     if (_showReasonInput)
//                       Padding(
//                         padding: const EdgeInsets.only(top: 16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Lý do không đạt:',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                             const SizedBox(height: 8),
//                             TextField(
//                               controller: _reasonController,
//                               maxLines: 3,
//                               decoration: InputDecoration(
//                                 border: const OutlineInputBorder(),
//                                 hintText: 'Nhập lý do...',
//                                 filled: true,
//                                 fillColor: isLightMode
//                                     ? Colors.white
//                                     : Colors.grey[800],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _showConfirmationDialog(BuildContext context, bool isPass) {
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
//                     const Text('Bạn có chắc chắn muốn đánh dấu tranh này là "Không Đạt"?'),
//                     const SizedBox(height: 8),
//                     if (_showReasonInput)
//                       TextField(
//                         controller: _reasonController,
//                         maxLines: 3,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           hintText: 'Nhập lý do...',
//                         ),
//                       ),
//                   ],
//                 ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Đóng popup
//               },
//               child: const Text('Hủy'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Đóng popup
//                 _saveResult(isPass);
//               },
//               child: const Text('Xác Nhận'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _saveResult(bool isPass) async {
//     String? reason = _showReasonInput ? _reasonController.text : null;
//     Painting updatedPainting = widget.paintings[currentIndex].copyWith(
//       borderColor: isPass ? Colors.green : Colors.red,
//     );
//     widget.onPaintingStatusUpdated(updatedPainting);

//     PaintingResult result = PaintingResult(
//       updatedPainting.id,
//       updatedPainting.name,
//       isPass,
//       reason,
//     );
//     await PaintingService.savePaintingResult(result);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           isPass
//               ? 'Tranh được đánh dấu là "Đạt"'
//               : 'Tranh được đánh dấu là "Không Đạt". Lý do: $reason',
//         ),
//       ),
//     );
//   }
// }
