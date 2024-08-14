import 'package:json_annotation/json_annotation.dart';

part 'map/painting_result.g.dart';

@JsonSerializable()
class PaintingResult {
  String? paintingId;
  String? code;
  String? awardId;
  bool isPass;
  String? reason;

  PaintingResult(this.paintingId ,this.code, this.awardId, this.isPass, this.reason);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  factory PaintingResult.fromJson(Map<String, dynamic> json) =>
      _$PaintingResultFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PaintingResultToJson(this);
}