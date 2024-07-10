import 'package:json_annotation/json_annotation.dart';

part 'map/schedule.g.dart';

@JsonSerializable()
class Schedule {
  String id;
  String? roundId;
  String? description;
  String? examinerId;
  String? status;

  Schedule(this.id, this.roundId, this.description, this.examinerId, this.status);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
