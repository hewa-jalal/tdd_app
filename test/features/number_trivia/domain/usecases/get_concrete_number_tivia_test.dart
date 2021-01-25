import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_app/domain/entities/number_trivia.dart';
import 'package:tdd_app/domain/repositories/number_trivia_repository.dart';
import 'package:tdd_app/domain/usecase/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  // create variables to store objects
  GetConcreteNumberTrivia useCase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    // instantiate objects
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
    // we are at the red phase so before writing test we should fix the red lines
  });

  final tNumber = 1;

  // will be returned from mock class
  final tNumberTrivia = NumberTrivia(text: 'test', number: tNumber);

  test(
    'should get trivia for the number from the repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      // act
      final result = await useCase(Params(number: tNumber));

      // assert
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
