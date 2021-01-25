import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_app/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });
  group('stringToUnassignedInt', () {
    test(
        'should return an integer when the string represent an unassigned integer',
        () async {
      // arrange
      final str = '123';
      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, Right(123));
    });

    test('should return a failure when the string is not an integer', () async {
      // arrange
      final str = 'abc';
      // or
      // final str = 1.0

      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('should return a failure when integer is negative', () async {
      // arrange
      final str = '-123';

      // act
      final result = inputConverter.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
