import 'package:flutter/material.dart';
import 'package:netvexanh_mobile/models/painting.dart';
import 'package:netvexanh_mobile/screens/full_image_screen.dart';

class PaintingDetailPopup extends StatelessWidget {
  final bool isAward;
  final Painting painting;
  final List<Painting> paintings;
  final Function(Painting) onPass;
  final Function(Painting) onNotPass;

  const PaintingDetailPopup({
    Key? key,
    required this.isAward,
    required this.painting,
    required this.paintings,
    required this.onPass,
    required this.onNotPass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) => _handleSwipe(context, details),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            if (painting.image != null) _buildImage(context),
            _buildPaintingDetails(),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          painting.code ?? 'Painting Detail',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.close, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullscreenImageScreen(imageUrl: painting.image!),
        ),
      ),
      child: Container(
        height: 200,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(painting.image!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildPaintingDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          painting.name ?? 'No Name',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          "Chủ Đề: ${painting.topicName ?? 'No Topic'}",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6AA758),
          ),
        ),
        SizedBox(height: 8),
        Text(
          painting.description ?? 'Không có chủ đề',
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: isAward ? null : () => onPass(painting),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: isAward ? Colors.grey : Colors.green,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Đạt', style: TextStyle(fontSize: 16)),
        ),
        ElevatedButton(
          onPressed: () => onNotPass(painting),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Không Đạt', style: TextStyle(fontSize: 16)),
        ),
      ],
    ),
  );
}


  void _handleSwipe(BuildContext context, DragEndDetails details) {
    int currentIndex = paintings.indexOf(painting);
    if (details.primaryVelocity! < 0 && currentIndex < paintings.length - 1) {
      Navigator.of(context).pop();
      _showDetailPopup(context, paintings[currentIndex + 1]);
    } else if (details.primaryVelocity! > 0 && currentIndex > 0) {
      Navigator.of(context).pop();
      _showDetailPopup(context, paintings[currentIndex - 1]);
    }
  }

  void _showDetailPopup(BuildContext context, Painting painting) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PaintingDetailPopup(
        isAward: isAward,
        painting: painting,
        paintings: paintings,
        onPass: onPass,
        onNotPass: onNotPass,
      ),
    );
  }
}
