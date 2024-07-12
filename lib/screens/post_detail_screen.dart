import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/screens/app_theme.dart';

class PosDetailScreen extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final List<String> imageUrls; // List of image URLs for images in the post

  const PosDetailScreen({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.imageUrls,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;

    return Scaffold(
      backgroundColor:
          isLightMode ? AppTheme.nearlyWhite : AppTheme.nearlyBlack,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isLightMode ? Colors.black : Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: isLightMode ? Colors.black : Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Images in Post:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isLightMode ? Colors.black : Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildImageGallery(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGallery() {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
                width: 120,
                height: 120,
              ),
            ),
          );
        },
      ),
    );
  }
}
