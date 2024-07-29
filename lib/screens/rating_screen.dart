import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/screens/app_theme.dart';
import 'package:netvexanh_mobile/models/schedule_award.dart';
import 'package:netvexanh_mobile/screens/painting_detail_screen.dart';
import 'package:netvexanh_mobile/screens/schedule_awards_screen.dart';
import 'package:netvexanh_mobile/screens/schedules_screen.dart';
import 'package:netvexanh_mobile/services/schedule_award_service.dart';
import 'package:netvexanh_mobile/services/schedule_service.dart';

class RatingScreen extends StatefulWidget {
  final String scheduleAwardId;

  const RatingScreen({super.key, required this.scheduleAwardId});

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  Set<String> selectedImageIds = {}; // Danh sách ID ảnh đã chọn
  final ScheduleService _scheduleService = ScheduleService();
  String? errorMessage; // Biến trạng thái để lưu thông báo lỗi
  ScheduleAward? scheduleAward;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScheduleAward();
  }

  Future<void> _loadScheduleAward() async {
    try {
      final fetchedScheduleAward = await ScheduleAwardService.getScheduleAwardById(widget.scheduleAwardId);
      setState(() {
        scheduleAward = fetchedScheduleAward;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load schedule award';
        isLoading = false;
      });
    }
  }

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
            appBar(context),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (scheduleAward == null)
              Center(child: Text(errorMessage ?? 'Failed to load schedule award'))
            else
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
                      itemCount: scheduleAward!.paintingViewModelsList?.length ?? 0,
                      itemBuilder: (context, index) {
                        final painting = scheduleAward!.paintingViewModelsList?[index];
                        final isSelected = selectedImageIds.contains(painting?.id); // Kiểm tra ID ảnh đã chọn
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedImageIds.remove(painting.id);
                              } else {
                                if (selectedImageIds.length < scheduleAward!.quantity!) {
                                  selectedImageIds.add(painting.id);
                                  errorMessage = null; // Xóa thông báo lỗi nếu có
                                } else {
                                  errorMessage = 'Chỉ có thể chọn ${scheduleAward!.quantity} ảnh';
                                }
                              }
                            });
                          },
                          onLongPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaintingDetailScreen(painting: painting),
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
                          bool success = await _scheduleService.postSelectedImages(scheduleAward!.scheduleId!, selectedImageIds.toList(), scheduleAward!.rank!);
                          if (success) {
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => ScheduleScreen()), // Điều hướng về ScheduleScreen
                              (Route<dynamic> route) => false, // Xóa tất cả các route trước đó
                            );
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

  Widget appBar(BuildContext context) {
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
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: isLightMode ? AppTheme.darkText : AppTheme.white),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => ScheduleAwardScreen(scheduleId: scheduleAward?.scheduleId ?? '')), // Điều hướng về ScheduleAwardScreen
                    (Route<dynamic> route) => false, // Xóa tất cả các route trước đó
                  );
                },
              ),
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
