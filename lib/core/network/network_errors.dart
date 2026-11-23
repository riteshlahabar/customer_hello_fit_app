import 'package:dio/dio.dart';

/// What the user is told when the request never reached the envelope.
///
/// Split out of `ApiClient` so that file stays under the project's 200-line
/// limit, and because this is the one piece of it a screen might want to
/// override per locale later — it is copy, not transport.
String networkMessageFor(DioExceptionType type) => switch (type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout =>
        'The server took too long to respond.',
      DioExceptionType.connectionError =>
        'No connection. Check your network and try again.',
      _ => 'Network error. Please try again.',
    };
