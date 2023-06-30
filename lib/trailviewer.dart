import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'trailviewer.g.dart';

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
  String baseUrl = 'https://trailview.cmparks.net';
  double navArrowMinAngle = -25;
  double navArrowMaxAngle = -20;
  String imageFetchType = 'standard';
  List<int>? filterSequences;

  TrailViewerBaseOptions();

  factory TrailViewerBaseOptions.fromJson(Map<String, dynamic> json) =>
      _$TrailViewerBaseOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$TrailViewerBaseOptionsToJson(this);
}

class TrailViewerBase extends StatefulWidget {
  const TrailViewerBase({super.key});

  @override
  State<TrailViewerBase> createState() => _TrailViewerBaseState();
}

void sendJson<T>(WebViewController controller, String type, T data) {
  controller.runJavaScript(
      'postMessage(`{"type": "$type", "data": ${json.encode(data)}}`)');
}

class _TrailViewerBaseState extends State<TrailViewerBase> {
  late final WebViewController _webviewController;

  @override
  void initState() {
    _webviewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("messageHandler", onMessageReceived: (message) {
        if (message.message == "init") {
          sendJson(_webviewController, "options", TrailViewerBaseOptions());
        }
        if (message.message == 'optionsSet') {
          sendJson(_webviewController, "start", null);
        }
      })
      ..loadRequest(
        Uri.parse('https://trailview.cmparks.net/embed/flutter'),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _webviewController);
  }
}
