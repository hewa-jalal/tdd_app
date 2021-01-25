import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_app/core/errors/failures.dart';
import 'package:tdd_app/core/usecases/usecase.dart';
import 'package:tdd_app/core/util/constants.dart';
import 'package:tdd_app/core/util/input_converter.dart';
import 'package:tdd_app/domain/entities/number_trivia.dart';
import 'package:tdd_app/domain/usecase/get_concrete_number_trivia.dart';
import 'package:tdd_app/domain/usecase/get_random_number_trivia.dart';
import 'package:tdd_app/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    // assert
    expect(TriviaEmpty(), equals(TriviaEmpty()));
  });

  group('GetTriviaConcreteNumber', () {
    final tNumberString = '1'; // parameter for GetConcreteNumberTrivia event
    final tNumberParsed = 1; // output of InputConverter
    final tNumberTrivia =
        NumberTrivia(text: 'test trivia', number: 1); // for Loaded event

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      setUpMockInputConverterSuccess();

      // act
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      // assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test('should emit [Error] when the input is invalid', () {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      // assert later
      final expected = [
        TriviaError(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expected),
      );
      // act
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should get data from ConcreteUseCase', () async {
      // arrange
      setUpMockInputConverterSuccess();

      // mock the usecase
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));
      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert later
      final expected = [
        TriviaLoading(),
        TriviaLoaded(trivia: tNumberTrivia),
      ];
      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expected),
      );
      // act
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [
        TriviaLoading(),
        TriviaError(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expected),
      );
      // act
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
    });

    test(
        'should emit [Loading, Error] with a proper message when getting data fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert later
      final expected = [
        TriviaLoading(),
        TriviaError(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expected),
      );
      // act
      bloc.add(GetTriviaForConcreteNumberEvent(tNumberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia =
        NumberTrivia(text: 'test trivia', number: 1); // for Loaded event

    test('should get data from RandomUseCase', () async {
      // arrange

      // mock the usecase
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // act
      bloc.add(GetTriviaForRandomNumberEvent());
      await untilCalled(mockGetRandomNumberTrivia(any));
      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // assert later
      final expected = [
        TriviaLoading(),
        TriviaLoaded(trivia: tNumberTrivia),
      ];
      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expected),
      );
      // act
      bloc.add(GetTriviaForRandomNumberEvent());
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [
        TriviaLoading(),
        TriviaError(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expected),
      );
      // act
      bloc.add(GetTriviaForRandomNumberEvent());
    });

    test(
        'should emit [Loading, Error] with a proper message when getting data fails',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert later
      final expected = [
        TriviaLoading(),
        TriviaError(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(
        bloc.asBroadcastStream(),
        emitsInOrder(expected),
      );
      // act
      bloc.add(GetTriviaForRandomNumberEvent());
    });
  });
}
