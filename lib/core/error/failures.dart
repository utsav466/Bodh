//local db failure

import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class LocalDatabaseFailure extends Failure{
  LocalDatabaseFailure({
    String message="Local database operation Failure"
  }) : super(message);




}

//API FAILURE

class ApiFailure extends Failure{
  final int? statusCode;

  const ApiFailure({
    this.statusCode,
    required String message
  }) : super(message);

}

