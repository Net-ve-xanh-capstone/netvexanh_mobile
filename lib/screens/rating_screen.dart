import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/models/painting.dart';
import 'package:netvexanh_mobile/models/painting_result.dart';
import 'package:netvexanh_mobile/models/schedule_award.dart';
import 'package:netvexanh_mobile/screens/full_image_screen.dart';
import 'package:netvexanh_mobile/screens/schedules_screen.dart';
import 'package:netvexanh_mobile/services/painting_service.dart';
import 'package:netvexanh_mobile/services/schedule_service.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class RatingScreen extends StatefulWidget {
  final String scheduleId;

  const RatingScreen({super.key, required this.scheduleId});

  @override
  // ignore: library_private_types_in_public_api
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen>
    with TickerProviderStateMixin {
  late List<Painting> _paintings;
  late List<ScheduleAward> _awards;
  // ignore: prefer_final_fields
  List<Painting>? _searchList;
  // ignore: prefer_final_fields
  List<PaintingResult> _results = [];
  late int _currentIndex;
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _fetchPaintings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chấm Điểm'),
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _resetSearch,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_isSearching)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Tìm kiếm theo mã tranh',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: _searchPaintings,
                    ),
                  ),
                ExpansionTile(
                  title: const Text(
                    'Giải Thưởng',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  children: [
                    for (var award in _awards)
                      ListTile(
                        title: Text(
                          award.rank,
                          style: const TextStyle(
                              fontSize:
                                  16), // Set the font size for the title text
                        ),
                        trailing: Text(
                          award.quantity.toString(),
                          style: const TextStyle(
                              fontSize:
                                  16), // Set the font size for the trailing text
                        ),
                      ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _searchList?.length ?? _paintings.length,
                    itemBuilder: (context, index) {
                      final painting = _searchList?[index] ?? _paintings[index];
                      return GestureDetector(
                        onTap: () => _showDetailPopup(painting),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 247, 245,
                                  245), // Set background color for the entire card
                              border: Border.all(
                                color: painting.borderColor ??
                                    Colors.transparent, // Change border color
                                width: 2, // Adjust border width as needed
                              ),
                              borderRadius: BorderRadius.circular(
                                  8), // Match the card's border radius
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    painting.rank ?? '',
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14, // Font size
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: painting.image != null
                                        ? Image.network(
                                            painting.image!,
                                            fit: BoxFit.cover,
                                          )
                                        : const Center(child: Text('No Image')),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    painting.code ?? 'Untitled',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: SpeedDial(
        icon: Icons.menu,
        activeIcon: Icons.close,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.list),
            label: 'Xem kết Quả',
            onTap: () => _showResultsPopup(_results),
          ),
          SpeedDialChild(
            child: const Icon(Icons.search),
            label: 'Tìm kiếm',
            onTap: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.auto_fix_high),
            label: 'Auto chọn Không đạt',
            onTap: () {
              // Kiểm tra nếu đã hết giải thì thực hiện auto chọn không đạt
              bool awardsRemaining =
                  _awards.any((award) => (award.quantity ?? 0) > 0);

              if (!awardsRemaining) {
                _autoMarkRemainingAsNotPass();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Vẫn còn giải thưởng chưa được trao!')),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _searchPaintings(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchList = null;
      } else {
        _searchList = _paintings
            .where((painting) =>
                painting.code!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _resetSearch() {
    setState(() {
      _searchList = null;
      _isSearching = false;
      _searchController.clear();
    });
  }

  Future<void> _fetchPaintings() async {
    try {
      var listPainting =
          await PaintingService.getScheduleById(widget.scheduleId);
      var listAward = await ScheduleService.getScheduleById(widget.scheduleId);
      setState(() {
        _awards = listAward;
        _paintings = listPainting;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load paintings: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDetailPopup(Painting painting) {
    _displayPopup(painting);
  }

  void _displayPopup(Painting painting) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              int currentIndex = _paintings.indexOf(painting);
              if (currentIndex < _paintings.length - 1) {
                Navigator.of(context).pop();
                _showDetailPopup(_paintings[currentIndex + 1]);
              }
            } else if (details.primaryVelocity! > 0) {
              int currentIndex = _paintings.indexOf(painting);
              if (currentIndex > 0) {
                Navigator.of(context).pop();
                _showDetailPopup(_paintings[currentIndex - 1]);
              }
            }
          },
          child: AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  painting.code ?? 'Painting Detail',
                  style: const TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
            content: SingleChildScrollView(
              // Add this
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Add this
                  children: [
                    if (painting.image != null)
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullscreenImageScreen(
                                imageUrl: painting.image!,
                              ),
                            ),
                          );
                        },
                        child: Image.network(
                          painting.image!,
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        painting.name ?? 'No Description',
                        style: const TextStyle(
                          fontSize: 20, // Kích thước lớn hơn cho tiêu đề
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Màu sắc cho tiêu đề
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Chủ Đề: ${painting.topicName ?? 'No Topic'}", // Đảm bảo có văn bản thay thế khi không có chủ đề
                        style: const TextStyle(
                          fontSize: 17, // Kích thước chữ cho chủ đề
                          fontWeight:
                              FontWeight.w600, // Trọng số chữ để nổi bật hơn
                          color: Color.fromARGB(
                              255, 106, 167, 88), // Màu sắc cho chủ đề
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        painting.description ?? 'No Description',
                        style: const TextStyle(
                          fontSize: 15, // Kích thước nhỏ hơn cho mô tả
                          color: Color.fromARGB(
                              255, 143, 140, 140), // Màu sắc cho moo ta
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _PassDialog(painting);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Đạt'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _NotPassDialog(painting);
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Không Đạt'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _NotPassDialog(Painting painting) {
    String reason = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác Nhận Không Đạt'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Bạn có chắc chắn muốn đánh dấu tranh này là "Không Đạt"?'),
              const SizedBox(height: 8),
              TextField(
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập lý do...',
                ),
                onChanged: (value) {
                  reason = value.trim(); // Trim any leading/trailing whitespace
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                _updatePaintingStatus(
                  painting,
                  false,
                  reason.isEmpty
                      ? 'Không đáp ứng tiêu chí'
                      : reason, // Default reason if empty
                  null,
                  null,
                );
              },
              child: const Text('Xác Nhận'),
            ),
          ],
        );
      },
    );
  }

  void _PassDialog(Painting painting) {
    String reason = '';
    String? selectedAwardId;
    String? selectedAwardRank;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Determine the default value if `selectedAwardId` is null
            if (selectedAwardId == null && _awards.isNotEmpty) {
              selectedAwardId = _awards.first.awardId;
              selectedAwardRank = _awards.first.rank.toString();
            }

            return AlertDialog(
              title: const Text('Chọn Giải Thưởng'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text('Chọn giải thưởng'),
                    value: selectedAwardId,
                    items: _awards.map((award) {
                      return DropdownMenuItem<String>(
                        value: award.awardId,
                        child: Text(award.rank.toString()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAwardId = value;
                        selectedAwardRank = _awards
                            .firstWhere((award) => award.awardId == value)
                            .rank
                            .toString();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nhập ghi chú (nếu có)...',
                    ),
                    onChanged: (value) {
                      reason = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: selectedAwardId == null
                      ? null
                      : () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          _updatePaintingStatus(
                            painting,
                            true,
                            reason.isEmpty
                                ? 'Bài dự thi đáp ứng tiêu chí'
                                : reason, // Default reason if empty
                            selectedAwardId!,
                            selectedAwardRank ??
                                'Chưa chọn giải thưởng', // Default rank if null
                          );
                        },
                  child: const Text('Xác Nhận'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updatePaintingStatus(
    Painting painting,
    bool isPass,
    String reason,
    String? selectedAwardId,
    String? award, {
    bool showNextPopup = true,
  }) async {
    // Kiểm tra xem painting có đạt hay không
    if (isPass) {
      // Nếu đạt, kiểm tra số lượng giải thưởng
      var awardIndex = _awards.indexWhere(
          (x) => x.awardId == selectedAwardId && (x.quantity ?? 0) > 0);

      if (awardIndex == -1) {
        // Nếu không còn giải thưởng, hiển thị thông báo và dừng tiến trình
        await _showWarningDialog('Giải Thưởng Đã Hết');
        return;
      }

      // Nếu còn giải, tiếp tục cập nhật painting và giảm số lượng giải
      var award = _awards[awardIndex];
      award.quantity = (award.quantity ?? 0) - 1;
      _awards[awardIndex] = award;
    }

    // Tiếp tục cập nhật trạng thái cho painting (set màu và rank)
    final updatedPainting = painting.copyWith(
      borderColor: isPass ? Colors.green : Colors.red,
      rank: isPass ? award : 'Không đạt',
    );

    setState(() {
      // Cập nhật danh sách paintings và search list nếu có
      int index = _paintings.indexWhere((p) => p.id == painting.id);
      if (index != -1) {
        _paintings[index] = updatedPainting;
      }

      if (_searchList != null) {
        int searchIndex = _searchList!.indexWhere((p) => p.id == painting.id);
        if (searchIndex != -1) {
          _searchList![searchIndex] = updatedPainting;
        }
      }
    });

    var newResult = PaintingResult(updatedPainting.id, selectedAwardId,
        updatedPainting.code, reason, isPass, award, painting.image);

    // Nếu painting không đạt, tăng lại số lượng giải thưởng
    if (!isPass) {
      var oldValue = _results
          .where((x) => x.paintingId == newResult.paintingId)
          .firstOrNull;
      if (oldValue != null) {
        _results.remove(oldValue);

        var awardIndex =
            _awards.indexWhere((x) => x.awardId == oldValue.awardId);
        if (awardIndex != -1) {
          var award = _awards[awardIndex];
          award.quantity = (award.quantity ?? 0) + 1;
          _awards[awardIndex] = award;
        }
      }
    }

    _results.add(newResult);

    // Di chuyển đến painting tiếp theo sau khi cập nhật trạng thái
    if (showNextPopup) {
      int nextIndex = _paintings.indexOf(updatedPainting) + 1;
      if (nextIndex < _paintings.length) {
        _showDetailPopup(_paintings[nextIndex]);
      }
    }
  }

  void _autoMarkRemainingAsNotPass() {
    setState(() {
      // Duyệt qua danh sách tranh và chọn những tranh chưa được chấm
      for (var painting in _paintings) {
        if (painting.rank == null || painting.rank == "") {
          _updatePaintingStatus(
              painting, false, 'Không đáp ứng tiêu chí', null, null,
              showNextPopup: false);
        }
      }
    });

    // Thông báo cho người dùng
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Tất cả các bức tranh còn lại đã được đánh dấu là Không đạt')),
    );
  }

  void _showResultsPopup(List<PaintingResult> results) {
    // Filter the results to include only those where isPass is true
    final passedResults = results.where((result) => result.isPass).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kết quả đạt'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SizedBox(
            height: 400,
            width: 300,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(
                        16.0), // Padding around the ListView
                    itemCount: passedResults.length,
                    itemBuilder: (context, index) {
                      final result = passedResults[index];
                      return Card(
                        elevation: 4.0, // Shadow depth for the card
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0), // Margin between cards
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(
                              16.0), // Padding inside each ListTile
                          title: Text(
                            '${result.code}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display the image if available
                              if (result.image != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Image.network(
                                    result.image!,
                                    height: 100, // Set image height
                                    width: double.infinity, // Full width
                                    fit: BoxFit.cover, // Fit image
                                  ),
                                ),
                              Text(
                                result.award ?? 'Không Đạt',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool canProceed =
                        await _checkConditionsAndShowWarnings(results);
                    if (canProceed) {
                      // Tiến hành gửi kết quả
                      String scheduleId = _awards[0].scheduleId.toString();

                      bool success =
                          await ScheduleService().rating(scheduleId, results);

                      // Hiển thị AlertDialog thay vì SnackBar
                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(success ? 'Thành Công' : 'Thất Bại'),
                            content: Text(
                              success
                                  ? 'Chấm bài thành công'
                                  : 'Gửi kết quả thất bại',
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Đóng AlertDialog
                                  if (success) {
                                    Navigator.of(context).pop();
                                    _navigateToScheduleScreen();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Gửi kết quả'),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAwardsPopup(List<ScheduleAward> awards) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Giải Thưởng'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SizedBox(
            height: 400,
            width: 300,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: awards.length,
                    itemBuilder: (context, index) {
                      final award = awards[index];
                      return Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16.0),
                          title: Text(
                            award.rank ?? 'Unknown Award',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          subtitle: Text(
                            'Số lượng: ${award.quantity ?? 0}',
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          leading: const Icon(
                            Icons.emoji_events,
                            color: Colors.amber,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _checkConditionsAndShowWarnings(
      List<PaintingResult> results) async {
    if (results.length != _paintings.length) {
      await _showWarningDialog('Vui Lòng Chấm Điểm Cho Tất Cả Bức Tranh');
      return false;
    }

    if (_awards.any((x) => x.quantity != 0)) {
      await _showWarningDialog('Số Lượng Tranh Đạt Giai Chưa Đủ');
      return false;
    }

    return true;
  }

  Future<void> _showWarningDialog(String message) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cảnh Báo'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _getRankIcon(ScheduleAward award) {
    switch (award.rank) {
      case 'Giải Nhất':
        return Image.asset('assets/images/1.png');
      case 'Giải Nhì':
        return Image.asset('assets/images/2.png');
      case 'Giải Ba':
        return Image.asset('assets/images/3.png');
      case 'Giải Khuyến Khích':
        return Image.asset('assets/images/4.png');
      default:
        return Image.asset('assets/images/0.png');
    }
  }

  void _navigateToScheduleScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleScreen(),
      ),
    );
  }
}
