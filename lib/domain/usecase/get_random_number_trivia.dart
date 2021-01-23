import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_app/core/errors/failures.dart';
import 'package:tdd_app/core/usecases/usecase.dart';
import 'package:tdd_app/domain/entities/number_trivia.dart';
import 'package:tdd_app/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
