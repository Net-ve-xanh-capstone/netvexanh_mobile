
import 'package:json_annotation/json_annotation.dart';

part 'map/painting.g.dart';

@JsonSerializable()
class Painting {

    String id;
    String? image;
    String? name;
    String? description;
    late DateTime submitTime;
    String? roundTopicId;
    String? scheduleId;
    String? status;
    String? code;
    String? ownerName;

  //Painting(this.Id, this.Image, this.Name, this.Description, this.SubmitTime, this.RoundTopicId, this.ScheduleId, this.Status, this.Code, this.OwnerName);
    Painting({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.submitTime,
    required this.roundTopicId,
    required this.scheduleId,
    required this.status,
    required this.code,
    required this.ownerName,
  });

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  factory Painting.fromJson(Map<String, dynamic> json) =>
      _$PaintingFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PaintingToJson(this);
}
