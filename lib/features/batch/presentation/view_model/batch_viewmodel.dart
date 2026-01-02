import 'package:bodh_flutter/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:bodh_flutter/features/batch/domain/usecases/get_all_batch_usecase.dart';
import 'package:bodh_flutter/features/batch/domain/usecases/update_batch_usecase.dart';
import 'package:bodh_flutter/features/batch/presentation/state/batch_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final batchViewmodelProvider =NotifierProvider<BatchViewmodel, BatchState>((){
  return BatchViewmodel();
  
});

class BatchViewmodel extends Notifier<BatchState>{
  late final GetAllBatchUsecase _getAllBatchUsecase;
  late final UpdateBatchUsecase _updateBatchUsecase;
  late final CreateBatchUsecase _createBatchUsecase;


  @override
  BatchState build() {
    // initialization
    _getAllBatchUsecase=ref.read(getAllBatchUsecaseProvider);
    _updateBatchUsecase=ref.read(UpdateBatchUsecaseProvider);
    _createBatchUsecase=ref.read(createBatchUsecaseProvider);
    return BatchState();
  }

  Future<void> getAllBatches()async{
    state=state.copyWith(status:  BatchStatus.loading);
        // wait for 2 seconds 
    // Future.delayed(Duration(seconds: 2),(){});
    await Future.delayed(Duration(seconds: 2));
    
    final result = await _getAllBatchUsecase();

    result.fold((left){
      state= state.copyWith(
        status:  BatchStatus.error,
        errorMessage: left.message,
      );
    }, (batches){
      state = state.copyWith(status: BatchStatus.loaded, batches: batches);
    });
  }


  //create batch
  Future<void> createBatch(String batchName) async{
    //progress bar lai spinn
    state = state.copyWith(status: BatchStatus.loaded);

    final result=await _createBatchUsecase(
      CreateBatchUsecaseParams(batchName: batchName),
    );

    //
    result.fold((left){
      return state=state.copyWith(
        status: BatchStatus.error,
        errorMessage: left.message
      );
    },(right){
      state =state.copyWith(
        status : BatchStatus.loaded
      );

    });

  }


} 

