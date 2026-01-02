
//Params
// make params here (wrapping all of it in one place)

import 'package:bodh_flutter/core/error/failures.dart';
import 'package:bodh_flutter/core/usecases/app_usecase.dart';
import 'package:bodh_flutter/features/batch/data/repositories/batch_repository.dart';
import 'package:bodh_flutter/features/batch/domain/entities/batch_entity.dart';
import 'package:bodh_flutter/features/batch/domain/repositories/batch_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateBatchUsecaseParams extends Equatable{
  final String batchName;
  
  CreateBatchUsecaseParams({required this.batchName});

  @override
  // TODO: implement props
  List<Object?> get props => [batchName];
}


final createBatchUsecaseProvider = Provider<CreateBatchUsecase>((ref){
  return CreateBatchUsecase(batchRepository: ref.read(batchRepositoryProvider));
});

//usecase
class CreateBatchUsecase 
implements UsecaseWithParams <bool, CreateBatchUsecaseParams>{
  final IBatchRepository _batchRepository;

  CreateBatchUsecase({required IBatchRepository batchRepository})
  : _batchRepository=batchRepository;


  @override
  Future<Either<Failure, bool>> call(CreateBatchUsecaseParams params) {
  //create batch entity here
  BatchEntity batchEntity= BatchEntity(batchName: params.batchName);
  return _batchRepository.createBatch(batchEntity);
  }

}