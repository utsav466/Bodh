


import 'package:bodh_flutter/core/constants/hive_table_constant.dart';
import 'package:bodh_flutter/features/auth/data/models/auth_hive_model.dart';
import 'package:bodh_flutter/features/batch/data/models/batch_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref){
  return HiveService();
});

class HiveService {
  // init 
  Future<void> init()async{
    final directory = await getApplicationDocumentsDirectory();
    
    final path = '${directory.path}/${HiveTableConstant.dbName}';
    Hive.init(path);
    _registerAdapter();
    await openBoxes();
    await insertDummybatches();
  }

  Future<void> insertDummybatches() async{
    
    final box =Hive.box<BatchHiveModel>(HiveTableConstant.batchTable);
    if(box.isNotEmpty) return;


    final dummyBatches =[
      BatchHiveModel(batchName: 'Kathmandu'),
      BatchHiveModel(batchName: 'Chitwan'),
      BatchHiveModel(batchName: 'Gorkha'),
      BatchHiveModel(batchName: 'Surkhet'),

    ];
    for(var batch in dummyBatches){
      await box.put(batch.batchId, batch);
    }
    await box.close();
  }

  //Register Adapters
  void _registerAdapter(){
    if(!Hive.isAdapterRegistered(HiveTableConstant.batchTypeId)){
      Hive.registerAdapter(BatchHiveModelAdapter());
    }
    //register other adapters here
    if(!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)){
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

  }

  //Open Boxes

  Future <void> openBoxes() async{
    await Hive.openBox <BatchHiveModel>(HiveTableConstant.batchTable);
    await Hive.openBox <AuthHiveModel>(HiveTableConstant.authTable);
  }


  //Close Boxes
  Future<void> close() async{
    await Hive.close();
    }


  //=========== batch Queries ==============

  Box<BatchHiveModel> get _batchBox =>
    Hive.box<BatchHiveModel> (HiveTableConstant.batchTable);


    //create
    //
    Future<BatchHiveModel> createBatch(BatchHiveModel model) async{
      await _batchBox.put(model.batchId,model);
      return model;
    }



    //getallbatch

    List<BatchHiveModel> getAllBatches(){
      return _batchBox.values.toList();
    }



    //update batch
    Future<void> updateBatch(BatchHiveModel model) async{
      await _batchBox.put(model.batchId, model);
    }

    //delete batch

    Future<void> deleteBatch(String batchId) async {
      await _batchBox.delete(batchId);
    }

    //====auth queries=====

    Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstant.authTable);

    Future<AuthHiveModel> registerUser(AuthHiveModel model) async{
      await _authBox.put(model.authId, model);
      return model;
    }
    //Login

    Future<AuthHiveModel?> loginUser(String email, String password)async{
      final users = _authBox.values.where(
        (user) => user.email == email && user.password == password,
        
        );
        if (users.isNotEmpty){
          return users.first;
        }
        return null;
    }


  //logout
  Future<void> logoutUser() async{ }

  //get current user
  AuthHiveModel? getCurrentUser(String authId){
    return _authBox.get(authId);
  }

  //is email exists
  bool isEmailExists(String email){
    final users = _authBox.values.where(
      (user) => user.email == email,
    );
    return users.isNotEmpty;
  }

}