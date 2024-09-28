import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/models/painting.dart';
import 'package:netvexanh_mobile/models/painting_result.dart';
import 'package:netvexanh_mobile/models/schedule_award.dart';
import 'package:netvexanh_mobile/screens/painting_detail.dart';
import 'package:netvexanh_mobile/screens/schedules_screen.dart';
import 'package:netvexanh_mobile/services/painting_service.dart';
import 'package:netvexanh_mobile/services/schedule_service.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:netvexanh_mobile/screens/app_theme.dart';

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
  late List<ScheduleAward> _dropDownAward;
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
        title: const Text('Chấm Điểm', style: _titleStyle),
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
                    style: _textStyle,
                  ),
                  children: [
                    for (var award in _sortAwards(_awards))
                      ListTile(
                        leading: SizedBox(
                          width: 30,
                          height: 30,
                          child: _getRankIcon(award),
                        ),
                        title: Text(
                          award.rank,
                          style: _textStyle,
                        ),
                        trailing: Text(
                          award.quantity.toString(),
                          style: _textStyle,
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
                              color: const Color.fromARGB(255, 247, 245,
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
            label: 'Xem kết quả',
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
            child: const Icon(Icons.auto_fix_high),
            label: 'Tự động chọn không đạt',
            onTap: () {
              // Kiểm tra nếu đã hết giải thì thực hiện auto chọn không đạt
              bool awardsRemaining =
                  _awards.any((award) => (award.quantity ?? 0) > 0);

              if (!awardsRemaining) {
                _autoMarkRemainingAsNotPass();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Vẫn còn giải thưởng chưa được trao!',
                          style: _textStyle)),
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
      listAward = _sortAwards(listAward);
      setState(() {
        _dropDownAward = listAward;
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
    bool allAwardsQuantityZero = _awards.every((award) => award.quantity == 0);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaintingDetailPopup(
        isAward: allAwardsQuantityZero,
        painting: painting,
        paintings: _paintings,
        onPass: (painting) {
          Navigator.of(context).pop();
          _PassDialog(painting);
        },
        onNotPass: (painting) {
          Navigator.of(context).pop();
          _NotPassDialog(painting);
        },
      ),
    );
  }

  void _NotPassDialog(Painting painting) {
    String reason = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác Nhận Không Đạt', style: _titleStyle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  'Bạn có chắc chắn muốn đánh dấu tranh này là "Không Đạt"?',
                  style: _textStyle),
              const SizedBox(height: 16),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Nhập lý do...',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                onChanged: (value) {
                  reason = value.trim();
                },
              ),
            ],
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updatePaintingStatus(
                  painting,
                  false,
                  reason.isEmpty ? 'Không đáp ứng tiêu chí' : reason,
                  null,
                  null,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
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
            if (selectedAwardId == null && _awards.isNotEmpty) {
              selectedAwardId = _awards.first.awardId;
              selectedAwardRank = _awards.first.rank.toString();
            }

            return AlertDialog(
              title: const Text('Chọn Giải Thưởng', style: _titleStyle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    isExpanded: true,
                    hint: const Text('Chọn giải thưởng'),
                    value: _dropDownAward.isNotEmpty &&
                            _dropDownAward.any(
                                (award) => award.awardId == selectedAwardId)
                        ? selectedAwardId
                        : null,
                    items: _dropDownAward.map((award) {
                      return DropdownMenuItem<String>(
                        value: award.awardId,
                        child: Text(award.rank.toString(), style: _textStyle),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedAwardId = value;
                        selectedAwardRank = _dropDownAward
                            .firstWhere((award) => award.awardId == value)
                            .rank
                            .toString();
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Nhập ghi chú (nếu có)...',
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) {
                      reason = value;
                    },
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child:
                      const Text('Hủy', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: selectedAwardId == null
                      ? null
                      : () async {
                          Navigator.of(context).pop();
                          Future.microtask(() {
                            _updatePaintingStatus(
                              painting,
                              true,
                              reason.isEmpty
                                  ? 'Bài dự thi đáp ứng tiêu chí'
                                  : reason,
                              selectedAwardId!,
                              selectedAwardRank ?? 'Chưa chọn giải thưởng',
                            );
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Xác Nhận'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showResultsPopup(List<PaintingResult> results) {
    final passedResults = results.where((result) => result.isPass).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kết quả đạt', style: _titleStyle),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: passedResults.length,
                    itemBuilder: (context, index) {
                      final result = passedResults[index];
                      return Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (result.image != null)
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12.0)),
                                child: Image.network(
                                  result.image!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${result.code}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    result.award ?? 'Không Đạt',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    bool canProceed =
                        await _checkConditionsAndShowWarnings(results);
                    if (canProceed) {
                      String scheduleId = _awards[0].scheduleId.toString();
                      bool success =
                          await ScheduleService().rating(scheduleId, results);

                      await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(success ? 'Thành Công' : 'Thất Bại'),
                            content: Text(
                                success
                                    ? 'Chấm bài thành công'
                                    : 'Gửi kết quả thất bại',
                                style: _titleStyle),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK', style: _titleStyle),
                                onPressed: () {
                                  Navigator.of(context).pop();
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Gửi kết quả'),
                )
              ],
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    // Check if the painting passes
    if (isPass) {
      // If it passes, check the award quantity
      var awardIndex = _awards.indexWhere(
          (x) => x.awardId == selectedAwardId && (x.quantity ?? 0) > 0);

      if (awardIndex == -1) {
        // If no awards left, show warning and stop the process
        await _showWarningDialog('Giải Thưởng Đã Hết');
        return;
      }

      // If awards are available, update the painting and decrease award quantity
      var selectedAward = _awards[awardIndex];
      selectedAward.quantity = (selectedAward.quantity ?? 0) - 1;
      _awards[awardIndex] = selectedAward;
    }

    // Update the painting status (set color and rank)
    final updatedPainting = painting.copyWith(
      borderColor: isPass ? Colors.green : Colors.red,
      rank: isPass ? award : 'Không đạt',
    );

    setState(() {
      // Update paintings list and search list if it exists
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

      // Create new result
      var newResult = PaintingResult(updatedPainting.id, selectedAwardId,
          updatedPainting.code, reason, isPass, award, painting.image);

      if (isPass) {
        var oldValue = _results
            .where((x) => x.paintingId == newResult.paintingId)
            .firstOrNull;
        if (oldValue != null) {
          _results.remove(oldValue);
        }
      }

      // If painting doesn't pass, increase award quantity
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

      // Add new result
      _results.add(newResult);
    });

    // Update the dropdown list for awards
    _dropDownAward = _awards.where((a) => a.quantity != 0).toList();

    // Move to next painting after updating status
    bool allAwardsQuantityZero = _awards.every((award) => award.quantity == 0);
    if (!allAwardsQuantityZero) {
      if (showNextPopup) {
        int nextIndex = _paintings.indexOf(updatedPainting) + 1;
        if (nextIndex < _paintings.length) {
          _showDetailPopup(_paintings[nextIndex]);
        }
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
      const SnackBar(
          content: Text(
              'Tất cả các bức tranh còn lại đã được đánh dấu là không đạt')),
    );
  }

  List<ScheduleAward> _sortAwards(List<ScheduleAward> awards) {
    final orderMap = {
      'Giải Nhất': 0,
      'Giải Nhì': 1,
      'Giải Ba': 2,
      'Giải Khuyến Khích': 3,
    };

    return List.from(awards)
      ..sort((a, b) {
        int orderA = orderMap[a.rank] ?? 4; // 4 for unknown ranks
        int orderB = orderMap[b.rank] ?? 4;
        return orderA.compareTo(orderB);
      });
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
          content: Text(message, style: _titleStyle),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK', style: _titleStyle),
            ),
          ],
        );
      },
    );
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

// Common styles
const TextStyle _titleStyle = TextStyle(
  fontFamily: "Roboto",
  fontSize: 24,
  fontWeight: FontWeight.w500,
  color: AppTheme.nearlyBlack,
);

// ignore: unused_element
const TextStyle _textStyle = TextStyle(
  fontFamily: "Roboto",
  fontWeight: FontWeight.w500,
  fontSize: 16,
  color: AppTheme.nearlyBlack,
);
