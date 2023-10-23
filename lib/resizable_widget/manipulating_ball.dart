import 'package:flutter/material.dart';

class ManipulatingBall extends StatefulWidget {
  const ManipulatingBall({
    required this.onDrag,
    super.key,
    this.sizeInfinity,
    this.height,
    this.width,
  });
  final bool? sizeInfinity;
  final double? height;
  final double? width;
  final void Function(double dx, double dy) onDrag;

  @override
  ManipulatingBallState createState() => ManipulatingBallState();
}

class ManipulatingBallState extends State<ManipulatingBall> {
  double ballDiameter = 60;
  late double initX;
  late double initY;

  void _handleDrag(DragStartDetails details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  void _handleUpdate(DragUpdateDetails details) {
    final dx = details.globalPosition.dx - initX;
    final dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      child: Container(
        width: widget.sizeInfinity != null && widget.sizeInfinity!
            ? widget.width
            : ballDiameter,
        height: widget.sizeInfinity != null && widget.sizeInfinity!
            ? widget.height
            : ballDiameter,
        decoration: BoxDecoration(
          shape: widget.sizeInfinity != null && widget.sizeInfinity!
              ? BoxShape.rectangle
              : BoxShape.circle,
        ),
      ),
    );
  }
}
