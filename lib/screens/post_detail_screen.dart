import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/models/post.dart'; // Thay đổi theo mô hình dữ liệu mới
import 'package:netvexanh_mobile/services/post_service.dart';

class PostDetailScreen extends StatefulWidget {
  final String postId;

  const PostDetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Future<Post> postDetail;

  @override
  void initState() {
    super.initState();
    postDetail = PostService.getPostDetails(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Always set to white
      appBar: AppBar(
        backgroundColor: Colors.white, // Always set to white
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true, // Ensure the title is centered
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/icon.png'),
              radius: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Netvexanh',
              style: TextStyle(
                fontSize: 20, // Increased font size
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<Post>(
        future: postDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load post details',
                    style: TextStyle(color: Colors.black)));
          } else if (!snapshot.hasData) {
            return Center(
                child: Text('No details found',
                    style: TextStyle(color: Colors.black)));
          } else {
            final post = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      if (post.images != null && post.images!.isNotEmpty)
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 300,
                            enableInfiniteScroll: true,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            viewportFraction: 0.9,
                            aspectRatio: 16 / 9,
                          ),
                          items: post.images!.map((image) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Image.network(
                                    image.url ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        post.title ?? 'No Title',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        post.description ?? 'No Description',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
