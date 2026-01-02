

// import 'package:bodh_flutter/core/error/failures.dart';
import 'package:bodh_flutter/features/batch/data/models/batch_hive_model.dart';
// import 'package:bodh_flutter/features/batch/domain/entities/batch_entity.dart';
// import 'package:dartz/dartz.dart';



abstract interface class IBatchDatasource{

  Future<List<BatchHiveModel>> getAllBatches();
  Future<BatchHiveModel?> getBatchById(String batchId);
  Future<bool> createBatch(BatchHiveModel model);
  Future<bool> updateBatch(BatchHiveModel model);
  Future<bool> deleteBatch(String batchId);
  


}