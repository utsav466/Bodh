import 'package:bodh_flutter/features/batch/domain/entities/batch_entity.dart';

class BatchApiModel {
  final String? id;
  final String batchName;
  final String? status;

  BatchApiModel({this.id, required this.batchName, this.status});

  //info: to JSON
  Map<String, dynamic> toJson() {
    return {'batchName': batchName};
  }

  //info: from JSON
  factory BatchApiModel.fromJson(Map<String, dynamic> json) {
    return BatchApiModel(
      id: json['_id'] as String,
      batchName: json['batchName'] as String,
      status: json['status'] as String,
    );
  }

  // info: to entity
  BatchEntity toEntity() {
    return BatchEntity(
      batchId: id,
    batchName: 'UK-$batchName',
    status: status);
  }

  // info: from entity
  factory BatchApiModel.fromEntity(BatchEntity entity) {
    return BatchApiModel(batchName: entity.batchName);
  }

  // info: to entity list
  static List<BatchEntity> toEntityList(List<BatchApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  // info: from entity list
}
