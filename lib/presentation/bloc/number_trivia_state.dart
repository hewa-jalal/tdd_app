part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class TriviaEmpty extends NumberTriviaState {}

class TriviaLoading extends NumberTriviaState {}

class TriviaLoaded extends NumberTriviaState {
  TriviaLoaded({@required this.trivia});

  final NumberTrivia trivia;

  @override
  List<Object> get props => [trivia];
}

class TriviaError extends NumberTriviaState {
  TriviaError({@required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
