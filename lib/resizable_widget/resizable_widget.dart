import 'package:flutter/material.dart';
import 'package:flutter_camera_test/resizable_widget/manipulating_ball.dart';
import 'package:flutter_camera_test/resizable_widget/model/resizable_widget_model.dart';

class ResizableWidget extends StatefulWidget {
  const ResizableWidget({
    required this.child,
    required this.values,
    required this.resizableWidgetModel,
    super.key,
    this.mock,
  });

  final Widget child;
  final ResizableWidgetModel resizableWidgetModel;
  final bool? mock;

  final void Function(ResizableWidgetModel resizableWidgetModel) values;
  @override
  ResizableWidgetState createState() => ResizableWidgetState();
}

class ResizableWidgetState extends State<ResizableWidget> {
  double ballDiameter = 60;
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
  void initState() {
    setState(() {
      if (widget.mock != null && widget.mock!) {
        top = widget.resizableWidgetModel.top;
        left = widget.resizableWidgetModel.left;
      } else {
        top = widget.resizableWidgetModel.top / 2 - height / 2;
        left = widget.resizableWidgetModel.left / 2 - width / 2;
      }
      height = widget.resizableWidgetModel.height;
      width = widget.resizableWidgetModel.width;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (top == 0 && left == 0) {
      try {
        top = widget.resizableWidgetModel.top / 2 - height / 2;
        left = widget.resizableWidgetModel.left / 2 - width / 2;
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
    widget.values(
      ResizableWidgetModel(
        left: left,
        height: height,
        width: width,
        top: top,
      ),
    );

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
