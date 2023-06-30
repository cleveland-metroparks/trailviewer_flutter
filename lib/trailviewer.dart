import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'trailviewer.g.dart';

class TrailViewImage {
  String id;
  num sequenceId;
  num latitude;
  num longitude;
  num bearing;
  bool flipped;
  num pitchCorrection;
  bool visibility;
  String? shtHash;
  TrailViewImage(
      {required this.id,
      required this.sequenceId,
      required this.latitude,
      required this.longitude,
      required this.bearing,
      required this.flipped,
      required this.pitchCorrection,
      required this.visibility,
      this.shtHash});
}

@JsonSerializable()
class LatLng {
  double latitude;
  double longitude;
  LatLng(this.latitude, this.longitude);

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);
}

@JsonSerializable()
class TrailViewerBaseOptions {
  String initialImageId = 'c96ba6029cad464e9a4b7f9a6b8ac0d5';
  LatLng? initialLatLng;
  String baseUrl = 'http://192.168.90.114:5173';
  String imageFetchType = 'standard';
  List<int>? filterSequences;

  TrailViewerBaseOptions();

  factory TrailViewerBaseOptions.fromJson(Map<String, dynamic> json) =>
      _$TrailViewerBaseOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$TrailViewerBaseOptionsToJson(this);
}

class TrailViewerBase extends StatefulWidget {
  final void Function(void)? onInitDone;
  final void Function(TrailViewImage image)? onImageChange;

  const TrailViewerBase({super.key, this.onInitDone, this.onImageChange});

  @override
  State<TrailViewerBase> createState() => TrailViewerBaseState();
}

void sendJson<T>(WebViewController controller, String type, T data) {
  controller.runJavaScript(
      'postMessage(`{"type": "$type", "data": ${json.encode(data)}}`)');
}

class CompleterWrapper<T> {
  Completer<T>? completer;

  CompleterWrapper();

  void reset() {
    this.completer = Completer<T>();
  }
}

class TrailViewerBaseState extends State<TrailViewerBase> {
  late final WebViewController _webviewController;

  final _bearingCompleter = CompleterWrapper<double?>();
  final _currentImageIdCompleter = CompleterWrapper<String?>();
  final _currentSequenceIdCompleter = CompleterWrapper<int?>();
  final _flippedCompleter = CompleterWrapper<bool?>();
  final _imageGeoCompleter = CompleterWrapper<LatLng?>();

  void goToImageId(String imageId) {
    sendJson(_webviewController, "goToImageId", imageId);
  }

  Future<T> _marshalledGet<T>(
    String messageType,
    CompleterWrapper<T> wrapper,
  ) {
    if (wrapper.completer != null && !wrapper.completer!.isCompleted) {
      return wrapper.completer!.future;
    }
    wrapper.reset();
    sendJson(_webviewController, messageType, null);
    return wrapper.completer!.future;
  }

  Future<double?> getBearing() async {
    return _marshalledGet("getBearing", _bearingCompleter);
  }

  Future<String?> getCurrentImageId() async {
    return _marshalledGet("getCurrentImageId", _currentImageIdCompleter);
  }

  Future<int?> getCurrentSequenceId() async {
    return _marshalledGet("getCurrentSequenceId", _currentSequenceIdCompleter);
  }

  Future<bool?> getFlipped() async {
    return _marshalledGet("getFlipped", _flippedCompleter);
  }

  Future<LatLng?> getImageGeo() async {
    return _marshalledGet("getImageGeo", _imageGeoCompleter);
  }

  @override
  void initState() {
    super.initState();
    _webviewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("messageHandler", onMessageReceived: (message) {
        final messageData = json.decode(message.message);
        if (messageData['type'] == 'init') {
          sendJson(_webviewController, "options", TrailViewerBaseOptions());
        } else if (messageData['type'] == 'optionsSet') {
          sendJson(_webviewController, "start", null);
        } else if (messageData['type'] == 'bearingGet') {
          _bearingCompleter.completer?.complete(
              messageData['data'] is double ? messageData['data'] : null);
        } else if (messageData['type'] == 'currentImageIdGet') {
          _currentImageIdCompleter.completer?.complete(messageData['data']);
        } else if (messageData['type'] == 'currentSequenceIdGet') {
          _currentSequenceIdCompleter.completer?.complete(messageData['data']);
        } else if (messageData['type'] == 'flippedGet') {
          _flippedCompleter.completer?.complete(messageData['data']);
        } else if (messageData['type'] == 'imageGeoGet') {
          _imageGeoCompleter.completer?.complete(messageData['data'] == null
              ? null
              : LatLng(messageData['data']['latitude'],
                  messageData['data']['longitude']));
        } else if (messageData['type'] == 'onImageChange') {
          if (widget.onImageChange != null) {
            final d = messageData['data'];
            widget.onImageChange!(TrailViewImage(
                id: d['id'],
                sequenceId: d['sequenceId'],
                latitude: d['latitude'],
                longitude: d['longitude'],
                bearing: d['bearing'],
                flipped: d['flipped'],
                pitchCorrection: d['pitchCorrection'],
                visibility: d['visibility'],
                shtHash: d['shtHash']));
          }
        }
      })
      ..loadRequest(
        Uri.parse('http://192.168.90.114:5173/embed/flutter'),
      );
  }

  @override
  void dispose() {
    sendJson(_webviewController, "destroy", null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _webviewController);
  }
}
