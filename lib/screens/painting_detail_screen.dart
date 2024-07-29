import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/models/painting.dart';
import 'package:netvexanh_mobile/screens/app_theme.dart';
import 'package:photo_view/photo_view.dart';

class PaintingDetailScreen extends StatelessWidget {
  final Painting painting;

  const PaintingDetailScreen({Key? key, required this.painting}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Scaffold(
      backgroundColor: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
      appBar: AppBar(
        title: Text(
          'Thông Tin Chi tiết',
          style: TextStyle(
            fontSize: 24,
            color: isLightMode ? AppTheme.darkText : AppTheme.white,
          ),
        ),
        backgroundColor: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
        iconTheme: const IconThemeData(
          color: AppTheme.white, // Đổi màu của nút leading sang màu trắng
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 43, 58, 58),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/icon.png'),
                      radius: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Netvexanh',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (painting.image != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(
                              backgroundColor: Colors.black,
                            ),
                            body: Center(
                              child: PhotoView(
                                imageProvider: NetworkImage(painting.image!),
                                backgroundDecoration: const BoxDecoration(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.network(
                        painting.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  painting.name ?? 'No Name',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  painting.description ?? 'No Description',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  'Code: ${painting.code ?? 'Unknown'}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Chủ Đề: ${painting.roundTopicId ?? 'Unknown'}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Họ và tên: ${painting.ownerName ?? 'Unknown'}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Submit Time: ${painting.submitTime.toString()}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
