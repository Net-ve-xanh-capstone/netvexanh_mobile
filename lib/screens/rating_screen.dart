import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/models/painting.dart';
import 'package:netvexanh_mobile/screens/app_theme.dart';
import '../models/test.dart';
import '../services/schedule_service.dart'; // Đường dẫn đến ScheduleService

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final Test test = Test(
    '1',
    3, // Số lượng ảnh có thể chọn
    [
      Painting(
        Id: '1',
        Image:
            'https://hpconnect.vn/wp-content/uploads/2020/02/anh-dep-cau-rong-da-nang-viet-nam-10.jpg',
        Name: 'Painting 1',
        Description: 'Description 1',
        SubmitTime: DateTime.now(),
        RoundTopicId: 'R1',
        ScheduleId: 'S1',
        Status: 'Completed',
        Code: 'C2',
        OwnerName: 'Owner 2',
      ),
      Painting(
        Id: '2',
        Image:
            'https://i.pinimg.com/originals/74/6b/27/746b27c541347a6d4b62be2f8f735115.jpg',
        Name: 'Painting 2',
        Description: 'Description 2',
        SubmitTime: DateTime.now(),
        RoundTopicId: 'R1',
        ScheduleId: 'S1',
        Status: 'Completed',
        Code: 'C2',
        OwnerName: 'Owner 2',
      ),
      Painting(
        Id: '3',
        Image:
            'https://th.bing.com/th/id/OIP.5SYt0p1NhUxZXqKVIon7_QHaE7?rs=1&pid=ImgDetMain',
        Name: 'Painting 3',
        Description: 'Description 3',
        SubmitTime: DateTime.now(),
        RoundTopicId: 'R1',
        ScheduleId: 'S1',
        Status: 'Completed',
        Code: 'C2',
        OwnerName: 'Owner 2',
      ),
      Painting(
        Id: '4',
        Image:
            'https://th.bing.com/th/id/OIP.RkyiF_F9Fumnd4655gsHtAAAAA?rs=1&pid=ImgDetMain',
        Name: 'Painting 4',
        Description: 'Description 4',
        SubmitTime: DateTime.now(),
        RoundTopicId: 'R1',
        ScheduleId: 'S1',
        Status: 'Completed',
        Code: 'C2',
        OwnerName: 'Owner 2',
      ),
      // Thêm các đối tượng Painting khác tương tự
    ],
  );

  Set<String> selectedImageIds = {}; // Danh sách ID ảnh đã chọn

  final ScheduleService _scheduleService = ScheduleService();

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
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: 1.5,
                ),
                itemCount: test.images.length,
                itemBuilder: (context, index) {
                  final painting = test.images[index];
                  final isSelected = selectedImageIds
                      .contains(painting.Id); // Kiểm tra ID ảnh đã chọn
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedImageIds.remove(painting.Id);
                        } else {
                          if (selectedImageIds.length < test.quantity) {
                            selectedImageIds.add(painting.Id);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Chỉ có thể chọn ${test.quantity} ảnh'),
                              ),
                            );
                          }
                        }
                      });
                    },
                    onLongPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaintingDetailScreen(painting: painting),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  isSelected ? Colors.blue : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(
                            painting.Image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (isSelected)
                          Positioned(
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
            ),
            ElevatedButton(
              onPressed: () {
                // Gửi danh sách ID của ảnh đã chọn đến API
                _scheduleService.postSelectedImages(
                    test.Id, selectedImageIds.toList());
              },
              child: const Text('Gửi danh sách ảnh đã chọn'),
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
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
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

  const PaintingDetailScreen({Key? key, required this.painting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(painting.Name ?? 'Chi tiết ảnh'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(painting.Image!),
            SizedBox(height: 16),
            Text(
              painting.Name ?? 'No Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              painting.Description ?? 'No Description',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text('Owner: ${painting.OwnerName ?? 'Unknown'}'),
            Text('Status: ${painting.Status ?? 'Unknown'}'),
            Text('Submit Time: ${painting.SubmitTime.toString()}'),
            Text('Round Topic ID: ${painting.RoundTopicId ?? 'Unknown'}'),
            Text('Schedule ID: ${painting.ScheduleId ?? 'Unknown'}'),
            Text('Code: ${painting.Code ?? 'Unknown'}'),
          ],
        ),
      ),
    );
  }
}
