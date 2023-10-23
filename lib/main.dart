import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_test/pages/show_file_page.dart';
import 'package:flutter_camera_test/resizable_widget/custom_painter.dart';
import 'package:flutter_camera_test/resizable_widget/model/resizable_widget_model.dart';
import 'package:flutter_camera_test/resizable_widget/resizable_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(const MaterialApp(home: OCRPage()));
}

/// CameraApp is the Main Application.
class OCRPage extends StatefulWidget {
  /// Default Constructor
  const OCRPage({super.key});

  @override
  State<OCRPage> createState() => _OCRPageState();
}

class _OCRPageState extends State<OCRPage> {
  late CameraController controller;
  double? captureHeight;
  double? captureWidth;
  double? captureTop;
  double? captureLeft;
  double screenHeight = 200;
  double screenWidth = 200;
  ValueNotifier<int> selectedItemValue = ValueNotifier(0);
  final ImagePicker _imagePicker = ImagePicker();
  ScreenshotController screenshotController = ScreenshotController();
  double transformX = 0;
  ValueNotifier<bool> isCapture = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (screenHeight == 200 && screenWidth == 200) {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
    }
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: CameraPreview(controller)),
            ResizableWidget(
              resizableWidgetModel: ResizableWidgetModel(
                height: 200,
                width: 300,
                top: screenHeight,
                left: screenWidth,
              ),
              values: (resizableWidget) {
                captureHeight = resizableWidget.height;
                captureWidth = resizableWidget.width;
                captureTop = resizableWidget.top;
                captureLeft = resizableWidget.left;
              },
              child: CustomPaint(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.3),
                      width: 100000,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                  ),
                  child: CustomPaint(
                    foregroundPainter: BorderPainter(),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  height: 200,
                  child: Column(
                    children: [scrollView(), bottomBar()],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get captureWidget => Stack(
        children: [
          Positioned.fill(child: CameraPreview(controller)),
          ResizableWidget(
            resizableWidgetModel: ResizableWidgetModel(
              height: captureHeight!,
              width: captureWidth!,
              top: captureTop!,
              left: captureLeft!,
            ),
            mock: true,
            values: (resizableWidget) {},
            child: CustomPaint(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white,
                    width: 100000,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                ),
                child: CustomPaint(
                  foregroundPainter: BorderPainter(),
                ),
              ),
            ),
          ),
        ],
      );

  Widget bottomBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 70, right: 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _getImageFromGallery(ImageSource.gallery),
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade900.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Icon(
                  Icons.image_search_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          cameraButton,
          const SizedBox(
            height: 45,
            width: 45,
          ),
        ],
      ),
    );
  }

  Widget get cameraButton => GestureDetector(
        onTap: () {
          screenshotController
              .captureFromWidget(
            captureWidget,
          )
              .then((image) {
            Navigator.of(context).push(
              MaterialPageRoute<dynamic>(
                builder: (context) => ShowFilePage(
                  file: image,
                ),
              ),
            );
          });
        },
        child: Container(
          height: 70,
          width: 70,
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      );

  Future<dynamic> _getImageFromGallery(ImageSource source) async {
    setState(() {});
    final pickedFile = await _imagePicker.pickImage(
      source: source,
    );
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9,
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9,
              ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Kırpıcı',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Kırpıcı',
            // doneButtonTitle: "done".tr,
            // cancelButtonTitle: "cancel".tr,
          ),
        ],
      );

      if (croppedFile != null) {
        // final File file = File(croppedFile.path);
        debugPrint('');
        // _processPickedFile(file);
      }
    }
  }

  Widget scrollView() {
    List<Widget> buildList() {
      return [
        RotatedBox(
          quarterTurns: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: selectedItemValue,
                builder: (context, value, child) => Text(
                  'TEXT BASED',
                  style: TextStyle(
                    fontSize: 16,
                    color: value == 0 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
        RotatedBox(
          quarterTurns: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: ValueListenableBuilder(
                valueListenable: selectedItemValue,
                builder: (context, value, child) => Text(
                  'MATH BASED',
                  style: TextStyle(
                    fontSize: 16,
                    color: value == 1 ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ];
    }

    return Center(
      child: SizedBox(
        height: 70,
        child: RotatedBox(
          quarterTurns: -1,
          child: ListWheelScrollView(
            onSelectedItemChanged: (value) => selectedItemValue.value = value,
            itemExtent: 140,
            diameterRatio: 1.5,
            physics: const FixedExtentScrollPhysics(), // Kaydırma fizikleri
            children: buildList(),
          ),
        ),
      ),
    );
  }
}
