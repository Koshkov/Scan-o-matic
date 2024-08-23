abstract class Failure {
  const Failure([List properties = const <dynamic>[]]);
}

class DatabaseFailure implements Failure {
  final String message;
  DatabaseFailure({required this.message});
}
