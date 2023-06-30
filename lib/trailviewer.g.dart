// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trailviewer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLng _$LatLngFromJson(Map<String, dynamic> json) => LatLng(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$LatLngToJson(LatLng instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

TrailViewerBaseOptions _$TrailViewerBaseOptionsFromJson(
        Map<String, dynamic> json) =>
    TrailViewerBaseOptions()
      ..initialImageId = json['initialImageId'] as String
      ..initialLatLng = json['initialLatLng'] == null
          ? null
          : LatLng.fromJson(json['initialLatLng'] as Map<String, dynamic>)
      ..baseUrl = json['baseUrl'] as String
      ..navArrowMinAngle = (json['navArrowMinAngle'] as num).toDouble()
      ..navArrowMaxAngle = (json['navArrowMaxAngle'] as num).toDouble()
      ..imageFetchType = json['imageFetchType'] as String
      ..filterSequences = (json['filterSequences'] as List<dynamic>)
          .map((e) => e as int)
          .toList();

Map<String, dynamic> _$TrailViewerBaseOptionsToJson(
        TrailViewerBaseOptions instance) =>
    <String, dynamic>{
      'initialImageId': instance.initialImageId,
      'initialLatLng': instance.initialLatLng,
      'baseUrl': instance.baseUrl,
      'navArrowMinAngle': instance.navArrowMinAngle,
      'navArrowMaxAngle': instance.navArrowMaxAngle,
      'imageFetchType': instance.imageFetchType,
      'filterSequences': instance.filterSequences,
    };
