import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GoogleMapSample(),
    );
  }
}

class GoogleMapSample extends StatefulWidget {
  @override
  _GoogleMapSampleState createState() => _GoogleMapSampleState();
}

class _GoogleMapSampleState extends State<GoogleMapSample> {
  double heading = 0;
  final _controller = Completer<GoogleMapController>();
  final _markers = <Marker>{};
  LatLng? ontapLatLng;
  final initLatLng = const LatLng(35.675, 139.770);
  double hoge = 14.5;
  ByteData? iconData;
  double maxZoomLevel = 18;
  double minZoomLevel = 6;

  late final _initPosition = CameraPosition(target: initLatLng, zoom: 14.5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map"),
      ),
      body: GoogleMap(
        onTap: (LatLng latLng) async {
          //print(latLng)
          ontapLatLng = latLng;
          await markerCreate(latLng);
        },

        onCameraMoveStarted: () {
          // print('カメラスタート比率は${zoomRatio}');
        },

        onCameraIdle: () async {
          // print('カメラエンド比率は${zoomRatio}');
          print('end');
        },
        //mapType: MapType.terrain,
        initialCameraPosition: _initPosition,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _onMapCreated(controller);
        },
        minMaxZoomPreference: MinMaxZoomPreference(minZoomLevel, maxZoomLevel),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onCameraMove: (cameraPosition) async {
          const base_number = 10;
          var zoom = (cameraPosition.zoom * base_number).floor() / base_number;
          final floorZoomValue = zoom.toString();
          print('比率は${cameraPosition.zoom.floor()}');
          print(rangeValueReturn(floorZoomValue));
          if (rangeValueReturn(floorZoomValue) == true) {
            print("動いてるで");
            await canvasZoomAction(cameraPosition.zoom);
          }
          //await canvasZoomAction(cameraPosition.zoom);
          //await zoomAction(cameraPosition.zoom);
          //print('比率は${cameraPosition.zoom}');
        },
      ),
    );
  }

  bool rangeValueReturn(String zoomValue) {
    String command = zoomValue;
    switch (command) {
      case '1.0':
        return true;
      case '2.0':
        return true;
      case '3.0':
        return true;
      case '4.0':
        return true;
      case '5.0':
        return true;
      case '6.0':
        return true;
      case '7.0':
        return true;
      case '8.0':
        return true;
      case '9.0':
        return true;
      case '10.0':
        return true;
      case '11.0':
        return true;
      case '12.0':
        return true;
      case '13.0':
        return true;
      case '14.0':
        return true;
      case '15.0':
        return true;
      case '16.0':
        return true;
      default:
        return false;
    }
  }

  void setPin(LatLng latLng) {
    Marker marker = Marker(
      icon: BitmapDescriptor.defaultMarker,
      markerId: MarkerId(latLng.toString()),
      position: latLng,
    );
    print(marker);
    setState(() {
      _markers.add(marker);
    });
  }

  // マップの初期構築
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    String value = await DefaultAssetBundle.of(context)
        .loadString('lib/json/mapstyle.json');
    GoogleMapController futureController = await _controller.future;
    futureController.setMapStyle(value);
  }

  // Future<void> widgetInIcon() async {
  //   String path = 'images/fire.png';
  //   final imageSize = Size(10, 10);
  //   final iconImage = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(size: imageSize), path);
  //   final marker = Marker(
  //     alpha: 0.5,
  //     icon: iconImage,
  //     markerId: MarkerId("marker1"),
  //     position: LatLng(35.681, 139.788888),
  //   );
  //   setState(() {
  //     _markers.add(marker);
  //   });
  // }

  Future<void> setIcon() async {
    String path = 'images/fire.png';

    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(2, 2)), path)
        .then((onValue) {
      Marker marker = Marker(
        alpha: 0.5,
        icon: onValue,
        markerId: MarkerId("marker1"),
        position: LatLng(35.681, 139.788888),
      );
      //print(marker);
      setState(() {
        _markers.add(marker);
      });
    });
  }

  // Future<void> onTapCallBack(LatLng latLng) async {
  //   final tapMarker =
  //       markerReturn(await assetImageEdit(200), latLng, onTapCallBack);
  //   _markers.add(tapMarker);
  //   print('Pinをタップしたよ');
  //   setState(() {});
  // }

  Future<void> onTapCanvasCallBack(LatLng latLng) async {
    final Uint8List canvasMarker = await getBytesFromCanvas(100, 100);

    final tapMarker =
        canvasReturn(await canvasMarker, latLng, onTapCanvasCallBack);
    _markers.add(tapMarker);
    print('Pinをタップしたよ');
    setState(() {});
  }

  // Future<void> zoomEndAction(double zoomRatio) async {
  //   print('😀zoomRatioは${zoomRatio}');
  //   final tmpMarkers = Set.from(_markers);
  //   for (final marker in tmpMarkers) {
  //     final latLng = marker.position;
  //     String path = 'images/fire.png';
  //     Size imageSize = Size(zoomRatio, zoomRatio);

  //     BitmapDescriptor iconImage = await BitmapDescriptor.fromAssetImage(
  //         ImageConfiguration(size: imageSize), path);
  //     final initMarker = Marker(
  //       alpha: 0.5,
  //       icon: iconImage,
  //       markerId: MarkerId(latLng.toString()),
  //       position: latLng,
  //     );
  //     markerAdd(initMarker);
  //   }
  //   setState(() {});
  // }

  // Future<void> zoomAction(double zoomRatio) async {
  //   print('😡zoomRatioは${zoomRatio * 16}');
  //   final tmpMarkers = Set.from(_markers);
  //   for (final marker in tmpMarkers) {
  //     final latLng = marker.position;
  //     final initMarker = Marker(
  //       markerId: MarkerId(latLng.toString()),
  //       icon: BitmapDescriptor.fromBytes(
  //           await assetImageEdit(zoomRatio.toInt() * 16)),
  //       position: latLng,
  //       onTap: () => onTapCallBack(latLng),
  //     );
  //     markerAdd(initMarker);
  //   }
  //   setState(() {});
  // }

  Future<void> canvasZoomAction(double zoomRatio) async {
    print('🥶zoomRatioは${zoomRatio.floor()}');
    final tmpMarkers = Set.from(_markers);
    final Uint8List canvasMarker = await getBytesFromCanvas(
        zoomRatio.toInt().floor() * 4, zoomRatio.toInt().floor() * 4);
    for (final marker in tmpMarkers) {
      final latLng = marker.position;
      final initMarker =
          canvasReturn(await canvasMarker, latLng, onTapCanvasCallBack);
      markerAdd(initMarker);
    }
    setState(() {});
  }

  Future<Uint8List> assetImageEdit(int iconsize) async {
    return await getBytesFromAsset('images/star_yellow.png', iconsize);
  }

  Future<void> markerCreate(LatLng latLng) async {
    //int iconsize = 100;
    final Uint8List markerIcon = await getBytesFromCanvas(50, 50);

    Marker initMarker = Marker(
      markerId: MarkerId(latLng.toString()),
      //icon: BitmapDescriptor.fromBytes(await assetImageEdit(100)),
      icon: BitmapDescriptor.fromBytes(markerIcon),
      position: latLng,
      onTap: () => onTapCanvasCallBack(latLng),
    );

    setState(() {
      markerAdd(initMarker);
    });
  }

  void markerAdd(Marker marker) {
    _markers.add(marker);
  }

  Future<void> loadIconData() async {
    iconData = await rootBundle.load('images/star_yellow.png');
  }

  @override
  void initState() {
    super.initState();
    // setIcon();
    //widgetInIcon();
    loadIconData();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ui.Codec codec = await ui.instantiateImageCodec(
        iconData!.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}

// Marker markerReturn(
//     Uint8List markerIcon, LatLng latLng, Future<void> Function(LatLng) onTap) {
//   return Marker(
//     markerId: MarkerId(latLng.toString()),
//     icon: BitmapDescriptor.fromBytes(markerIcon),
//     position: latLng,
//     onTap: () => onTap(latLng),
//   );
// }

Marker canvasReturn(
    Uint8List markerIcon, LatLng latLng, Future<void> Function(LatLng) onTap) {
  return Marker(
    markerId: MarkerId(latLng.toString()),
    icon: BitmapDescriptor.fromBytes(markerIcon),
    position: latLng,
    onTap: () => onTap(latLng),
  );
}

Color colorReturn(int value) {
  String parameters = value.toString();
  int yellowValue = yellowValueReturn(parameters);
  ui.Color? yellow = Colors.yellow[yellowValue];
  print(yellow);
  return yellow!;
}

int yellowValueReturn(String zoomValue) {
  String value = zoomValue;
  switch (value) {
    case '1.0':
      return 400;
    case '2.0':
      return 400;
    case '3.0':
      return 400;
    case '4.0':
      return 300;
    case '5.0':
      return 300;
    case '6.0':
      return 300;
    case '7.0':
      return 200;
    case '8.0':
      return 200;
    case '9.0':
      return 200;
    case '10.0':
      return 100;
    case '11.0':
      return 100;
    case '12.0':
      return 100;
    case '13.0':
      return 100;
    case '14.0':
      return 50;
    case '15.0':
      return 50;
    case '16.0':
      return 50;
    default:
      return 500;
  }
}

Future<Uint8List> getBytesFromCanvas(int width, int height) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  Color yellowcolors = colorReturn(width);
  final Paint paint = Paint()..color = yellowcolors;
  final Radius radius = Radius.circular(30.0);

  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      paint);

  TextPainter Painter = TextPainter(textDirection: TextDirection.ltr);
  Painter.text = TextSpan(
    text: 'H',
    style: TextStyle(fontSize: 25.0, color: Colors.white),
  );
  Painter.layout();
  Painter.paint(
      canvas,
      Offset((width * 0.5) - Painter.width * 0.5,
          (height * 0.5) - Painter.height * 0.5));
  final img = await pictureRecorder.endRecording().toImage(width, height);
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data!.buffer.asUint8List();
}
