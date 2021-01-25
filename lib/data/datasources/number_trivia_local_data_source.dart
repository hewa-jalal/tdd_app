import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_app/core/errors/exceptions.dart';
import 'package:tdd_app/core/util/constants.dart';
import 'package:tdd_app/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  // caching the model
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

// implementation
class SharedPreferencesNumberTriviaLocalDataSource
    extends NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  SharedPreferencesNumberTriviaLocalDataSource(this.sharedPreferences);
  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    // just a dummy data to satisfy the lint
    return sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      json.encode(triviaToCache.toJson()),
    );
  }
}
