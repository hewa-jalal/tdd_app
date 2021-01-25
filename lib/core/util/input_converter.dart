import 'package:dartz/dartz.dart';
import 'package:tdd_app/core/errors/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) {
        throw FormatException(); // as this throw will lead to the catch clause below
      }
      return Right(integer);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
