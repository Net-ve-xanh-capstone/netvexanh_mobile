import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/models/painting.dart';
import 'package:netvexanh_mobile/screens/app_theme.dart';
import 'package:netvexanh_mobile/models/schedule_award.dart';
import 'package:netvexanh_mobile/services/schedule_service.dart';

class RatingScreen extends StatefulWidget {
  final ScheduleAward scheduleAward;

  const RatingScreen({super.key, required this.scheduleAward});

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  Set<String> selectedImageIds = {}; // Danh sách ID ảnh đã chọn
  final ScheduleService _scheduleService = ScheduleService();
  String? errorMessage; // Biến trạng thái để lưu thông báo lỗi

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: <Widget>[
            appBar(),
            Expanded(
              child: Stack(
                children: [
                  GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: widget.scheduleAward.paintingViewModelsList?.length,
                    itemBuilder: (context, index) {
                      final painting = widget.scheduleAward.paintingViewModelsList?[index];
                      final isSelected = selectedImageIds.contains(painting?.id); // Kiểm tra ID ảnh đã chọn
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedImageIds.remove(painting!.id);
                            } else {
                              if (selectedImageIds.length < widget.scheduleAward.quantity!) {
                                selectedImageIds.add(painting!.id);
                                errorMessage = null; // Xóa thông báo lỗi nếu có
                              } else {
                                errorMessage = 'Chỉ có thể chọn ${widget.scheduleAward.quantity} ảnh';
                              }
                            }
                          });
                        },
                        onLongPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaintingDetailScreen(painting: painting!),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.transparent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.network(
                                painting!.image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (isSelected)
                              const Positioned(
                                top: 8,
                                right: 8,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  if (errorMessage != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  errorMessage = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0, // Loại bỏ bóng đổ
                      ),
                      onPressed: () async {
                        // Gửi danh sách ID của ảnh đã chọn đến API
                        bool success = await _scheduleService.postSelectedImages(widget.scheduleAward.scheduleId!, selectedImageIds.toList(), widget.scheduleAward.rank!);
                        if (success) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context); // Trở về trang trước đó
                        }
                      },
                      child: const Text('Gửi danh sách ảnh đã chọn'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Flutter UI',
                  style: TextStyle(
                    fontSize: 22,
                    color: isLightMode ? AppTheme.darkText : AppTheme.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              color: isLightMode ? Colors.white : AppTheme.nearlyBlack,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
                  child: Icon(
                    Icons.dashboard,
                    color: isLightMode ? AppTheme.dark_grey : AppTheme.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaintingDetailScreen extends StatelessWidget {
  final Painting painting;

  const PaintingDetailScreen({super.key, required this.painting});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(painting.name ?? 'Chi tiết ảnh'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(painting.image!),
            const SizedBox(height: 16),
            Text(
              painting.name ?? 'No Name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              painting.description ?? 'No Description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('Owner: ${painting.ownerName ?? 'Unknown'}'),
            Text('Status: ${painting.status ?? 'Unknown'}'),
            Text('Submit Time: ${painting.submitTime.toString()}'),
            Text('Round Topic ID: ${painting.roundTopicId ?? 'Unknown'}'),
            Text('Schedule ID: ${painting.scheduleId ?? 'Unknown'}'),
            Text('Code: ${painting.code ?? 'Unknown'}'),
          ],
        ),
      ),
    );
  }
}