
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

part 'map/painting.g.dart';

@JsonSerializable()
class Painting {

    String id;
    String? image;
    String? name;
    String? description;
    String? topicName;
    String? scheduleId;
    String? status;
    String? code;
    String? ownerName;
    Color? borderColor;

  //Painting(this.Id, this.Image, this.Name, this.Description, this.SubmitTime, this.topicName, this.ScheduleId, this.Status, this.Code, this.OwnerName);
    Painting({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.topicName,
    required this.scheduleId,
    required this.status,
    required this.code,
    required this.ownerName,
    this.borderColor,
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

 // Define the copyWith method
  Painting copyWith({
    String? id,
    String? image,
    String? name,
    String? description,
    String? topicName,
    String? scheduleId,
    String? status,
    String? code,
    String? ownerName,
    Color? borderColor,
  }) {
    return Painting(
      id: id ?? this.id,
      image: image ?? this.image,
      name: name ?? this.name,
      description: description ?? this.description,
      topicName: topicName ?? this.topicName,
      scheduleId: scheduleId ?? this.scheduleId,
      status: status ?? this.status,
      code: code ?? this.code,
      ownerName: ownerName ?? this.ownerName,
      borderColor: borderColor ?? this.borderColor,
    );
  }
  
}
