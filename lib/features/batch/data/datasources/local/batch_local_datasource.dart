
import 'package:bodh_flutter/core/services/hive/hive_service.dart';
import 'package:bodh_flutter/features/batch/data/datasources/batch_datasource.dart';
import 'package:bodh_flutter/features/batch/data/models/batch_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final batchLocalDataSourceProvider= Provider<BatchLocalDatasource>((ref){
  return BatchLocalDatasource(hiveService: ref.read(hiveServiceProvider));
  
});

class BatchLocalDatasource implements IBatchDatasource{
  //Dependency injection
  final HiveService _hiveService;
  
  BatchLocalDatasource({required HiveService hiveService})
  :_hiveService =hiveService;


  @override
  Future<bool> createBatch(BatchHiveModel entity) async{

    try {
      await _hiveService.createBatch(entity);
      return true;
      
    } catch (e) {
      return false;
      
    }
    // // TODO: implement createBatch
    // throw UnimplementedError();
  }

  @override
  Future<bool> deleteBatch(String batchId) {
    // TODO: implement deleteBatch
    throw UnimplementedError();
  }



  @override
  Future<List<BatchHiveModel>> getAllBatches() async{
  try {
    return _hiveService.getAllBatches();
    
  } catch (e) {
    return[];
    
  }
  }


  

  @override
  Future<BatchHiveModel> getBatchById(String batchId) {
    // TODO: implement getBatchById
    throw UnimplementedError();
  }

  @override
  Future<bool> updateBatch(BatchHiveModel entity) {
    // TODO: implement updateBatch
    throw UnimplementedError();
  }
} 