import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tdd_app/core/errors/failures.dart';
import 'package:tdd_app/core/usecases/usecase.dart';
import 'package:tdd_app/core/util/constants.dart';
import 'package:tdd_app/core/util/input_converter.dart';
import 'package:tdd_app/domain/entities/number_trivia.dart';
import 'package:tdd_app/domain/usecase/get_concrete_number_trivia.dart';
import 'package:tdd_app/domain/usecase/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(TriviaEmpty());

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumberEvent) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      // everything that will be yield in fold method will be yielded as a stream for bloc
      // TriviaError is yielded inside fold method then its yielded to bloc by using yield*

      // first fold is either we going to get a failure or success from InputConversion
      // second fold is when conversion is successful but we check for network request either too
      yield* inputEither.fold(
        (failure) async* {
          yield TriviaError(message: INVALID_INPUT_FAILURE_MESSAGE);
        },
        (integer) async* {
          // conversion is successful and we have the correct integer
          yield TriviaLoading();
          final failureOrTrivia =
              await getConcreteNumberTrivia(Params(number: integer));

          yield* _eitherLoadedOrErrorState(failureOrTrivia);
        },
      );
    } else if (event is GetTriviaForRandomNumberEvent) {
      yield TriviaLoading();
      final failureOrTrivia = await getRandomNumberTrivia(NoParams());

      yield* _eitherLoadedOrErrorState(failureOrTrivia);
    }
  }

  Stream<NumberTriviaState> _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> failureOrTrivia,
  ) async* {
    yield failureOrTrivia.fold(
      (failure) => TriviaError(message: _mapFailureToMessage(failure)),
      (trivia) => TriviaLoaded(trivia: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
