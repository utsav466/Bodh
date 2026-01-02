
import 'package:bodh_flutter/core/error/failures.dart';
import 'package:dartz/dartz.dart';

// has usecase in items,domaina and so on..
abstract interface class UsecaseWithParams<SuccessType, Params>{

  Future<Either<Failure, SuccessType>> call(Params params);

}


abstract interface class UsecaseWithoutParams<SuccessType>{

  Future<Either<Failure, SuccessType>> call();

}




// abstract interface class UsecaseWithParams<SuccessType, Params> {
//   Future<Either<Failure, SuccessType>> call(Params params);
// }

// abstract interface class UsecaseWithoutParams<SuccessType> {
//   Future<Either<Failure, SuccessType>> call();
// }
