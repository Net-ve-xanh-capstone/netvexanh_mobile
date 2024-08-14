import 'package:json_annotation/json_annotation.dart';
import 'package:netvexanh_mobile/models/painting.dart';

part 'map/schedule_award.g.dart';

@JsonSerializable()
class ScheduleAward {
  String id;
  int? quantity;
  String? awardId;
  String? rank;
  String? scheduleId;
  String? status;
  List<Painting> paintingViewModelsList;


  ScheduleAward(this.id, this.quantity, this.awardId, this.rank, this.scheduleId, this.status, this.paintingViewModelsList);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.

  factory ScheduleAward.fromJson(Map<String, dynamic> json) =>
      _$ScheduleAwardFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ScheduleAwardToJson(this);
}
