

import 'package:bodh_flutter/core/error/failures.dart';
import 'package:bodh_flutter/features/batch/domain/entities/batch_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IBatchRepository {

  Future<Either<Failure,List<BatchEntity>>> getAllBatches();// parameterless
  Future<Either<Failure,BatchEntity>> getBatchById(String batchId);// parameterized
  Future<Either<Failure,bool>> createBatch(BatchEntity entity);
  Future<Either<Failure, bool>> updateBatch(BatchEntity entity);
  Future<Either<Failure, bool>> deleteBatch(String batchId);

  


}


//Return type : J pani huna sakyo
//parameter jpani huna sakyo
//int add(int a, int b)
// double add(double b)
//generic class
//T add(y)
// successType add(params)

