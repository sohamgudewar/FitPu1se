import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

final class ComparisonScreen extends StatefulWidget {
  final String image1;
  final String image2;
  const ComparisonScreen({super.key, required this.image1, required this.image2});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

final class _ComparisonScreenState extends State<ComparisonScreen> {
  bool _showOverlay = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compare'),
        actions: [
          IconButton(
            icon: Icon(_showOverlay ? Icons.grid_on : Icons.grid_off),
            tooltip: 'Pose overlay',
            onPressed: () => setState(() => _showOverlay = !_showOverlay),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(child: _photoView(widget.image1, theme)),
          SizedBox(width: 2, child: Container(color: theme.colorScheme.outlineVariant)),
          Expanded(child: _photoView(widget.image2, theme)),
        ],
      ),
    );
  }

  Widget _photoView(String url, ThemeData theme) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PhotoView(
          imageProvider: NetworkImage(url),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
          backgroundDecoration: BoxDecoration(color: theme.colorScheme.surface),
        ),
        if (_showOverlay) _poseOverlay(theme),
      ],
    );
  }

  Widget _poseOverlay(ThemeData theme) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _GuidePainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

final class _GuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);

    paint.strokeWidth = 2;
    paint.color = Colors.white.withValues(alpha: 0.08);

    canvas.drawCircle(center, size.width * 0.35, paint);
    canvas.drawRect(
      Rect.fromCenter(center: center, width: size.width * 0.5, height: size.height * 0.7),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
