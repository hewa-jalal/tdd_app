import 'package:dartz/dartz.dart';
import 'package:tdd_app/core/errors/failures.dart';
import 'package:tdd_app/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
