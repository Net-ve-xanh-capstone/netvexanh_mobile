import 'dart:async';
import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/models/list_post.dart';
import 'package:netvexanh_mobile/screens/app_theme.dart';
import 'package:netvexanh_mobile/screens/post_detail_screen.dart';
import 'package:netvexanh_mobile/services/post_service.dart';

class PostScreen extends StatefulWidget {
  PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  List<ListPost> posts = [];
  int currentPage = 1;
  int pageSize = 2;
  int totalPages = 1;
  bool isLoading = false;
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          _fetchPosts();
        }
      }
    });
  }

  Future<void> _fetchPosts() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final result = await PostService.getPosts(pageSize, currentPage);
      setState(() {
        posts = result['list'];
        totalPages = result['totalPage'];
        isDataLoaded = true;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load posts: $error')),
      );
    } finally {
      setState(() {
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
      appBar: AppBar(
        title: Text(
          'Post List',
          style: TextStyle(
            fontSize: 24,
            color: isLightMode ? AppTheme.darkText : AppTheme.white,
          ),
        ),
        backgroundColor: isLightMode ? AppTheme.white : AppTheme.nearlyBlack,
        leading: Container(),
      ),
      body: Column(
        children: [
          Expanded(
            child: isDataLoaded
                ? ListView.builder(
                    controller: _scrollController,
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return GestureDetector(
                        onTap: () {
                          if (isDataLoaded) {
                            _navigateToPostDetail(post.id!);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color.fromARGB(255, 37, 53, 53),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(66, 255, 252, 252),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.title ?? 'No Title',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: post.image != null
                                    ? Image.network(
                                        post.image!,
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/userImage.png',
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          _buildPageSelector(),
        ],
      ),
    );
  }

  void _navigateToPostDetail(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(postId: id),
      ),
    );
  }

  Widget _buildPageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalPages, (index) {
          int pageNumber = index + 1;
          return InkWell(
            onTap: () {
              setState(() {
                currentPage = pageNumber;
                isDataLoaded = false;
                _fetchPosts();
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: currentPage == pageNumber
                    ? Colors.blue
                    : Colors.grey.shade300.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Text(
                pageNumber.toString(),
                style: TextStyle(
                  color:
                      currentPage == pageNumber ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
