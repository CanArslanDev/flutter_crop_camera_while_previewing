import 'package:flutter/material.dart';

class ResizableWidget extends StatefulWidget {
  const ResizableWidget(
      {super.key,
      required this.child,
      required this.height,
      required this.width,
      required this.values,
      required this.top,
      required this.left,
      this.mock});

  final Widget child;
  final double height;
  final double width;
  final double top;
  final double left;
  final bool? mock;

  final void Function(double height, double width, double top, double left)
      values;
  @override
  ResizableWidgetState createState() => ResizableWidgetState();
}

const ballDiameter = 60.0;

class ResizableWidgetState extends State<ResizableWidget> {
  double height = 200;
  double width = 300;

  double top = 0;
  double left = 0;
  bool firstOpening = false;
  void onDrag(double dx, double dy) {
    final newHeight = height + dy;
    final newWidth = width + dx;

    setState(() {
      height = newHeight > 0 ? newHeight : 0;
      width = newWidth > 0 ? newWidth : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (firstOpening == false) {
      print("a");
      setState(() {
        if (widget.mock != null && widget.mock == true) {
          top = widget.top;
          left = widget.left;
        } else {
          top = widget.top / 2 - height / 2;
          left = widget.left / 2 - width / 2;
        }
        height = widget.height;
        width = widget.width;
        firstOpening = true;
      });
    } else {
      if (top == 0 && left == 0) {
        try {
          top = widget.top / 2 - height / 2;
          left = widget.left / 2 - width / 2;
        } catch (e) {
          debugPrint(e.toString());
        }
      } else if (top > 436) {
        top = 436;
      } else if (top < 70) {
        top = 70;
      }
      if (height < 50) height = 50;
      if (width < 50) width = 50;
      widget.values(height, width, top, left);
    }
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: Container(
            height: height,
            width: width,
            color: Colors.transparent,
            child: widget.child,
          ),
        ),
        // center center
        Positioned(
          top: top,
          left: left,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              setState(() {
                top = top + dy;
                left = left + dx;
              });
            },
            sizeInfinity: true,
            height: height,
            width: width,
          ),
        ),
        // top left
        Positioned(
          top: top - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              final mid = (dx + dy) / 2;
              final newHeight = height - 2 * mid;
              final newWidth = width - 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top + mid;
                left = left + mid;
              });
            },
          ),
        ),
        // top middle
        Positioned(
          top: top - ballDiameter / 2,
          left: left + width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              final newHeight = height - dy;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                top = top + dy;
              });
            },
          ),
        ),
        // top right
        Positioned(
          top: top - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              final mid = (dx + (dy * -1)) / 2;

              final newHeight = height + 2 * mid;
              final newWidth = width + 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top - mid;
                left = left - mid;
              });
            },
          ),
        ),
        // center right
        Positioned(
          top: top + height / 2 - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              final newWidth = width + dx;

              setState(() {
                width = newWidth > 0 ? newWidth : 0;
              });
            },
          ),
        ),
        // bottom right
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              final mid = (dx + dy) / 2;

              final newHeight = height + 2 * mid;
              final newWidth = width + 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top - mid;
                left = left - mid;
              });
            },
          ),
        ),
        // bottom center
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left + width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              final newHeight = height + dy;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
              });
            },
          ),
        ),
        // bottom left
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              final mid = ((dx * -1) + dy) / 2;

              final newHeight = height + 2 * mid;
              final newWidth = width + 2 * mid;

              setState(() {
                height = newHeight > 0 ? newHeight : 0;
                width = newWidth > 0 ? newWidth : 0;
                top = top - mid;
                left = left - mid;
              });
            },
          ),
        ),
        //left center
        Positioned(
          top: top + height / 2 - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              final newWidth = width - dx;

              setState(() {
                width = newWidth > 0 ? newWidth : 0;
                left = left + dx;
              });
            },
          ),
        ),
      ],
    );
  }
}

class ManipulatingBall extends StatefulWidget {
  const ManipulatingBall({
    super.key,
    required this.onDrag,
    this.sizeInfinity,
    this.height,
    this.width,
  });
  final bool? sizeInfinity;
  final double? height;
  final double? width;
  final void Function(double dx, double dy) onDrag;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
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
