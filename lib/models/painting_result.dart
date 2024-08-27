import 'package:json_annotation/json_annotation.dart';

part 'map/painting_result.g.dart';

@JsonSerializable()
class PaintingResult {
  String? paintingId;
  String? awardId;
  String? reason;
  String? code;
  String? award;
  bool isPass;
  String? image;
  

  PaintingResult(this.paintingId ,this.awardId, this.code, this.reason, this.isPass, this.award, this.image);

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