import 'package:sidb/core/log/logging.dart';
import 'package:dio/dio.dart';

abstract class UseCase {
  Future<Result<R>> handle<R>(Future<R> Function() request) async {
    R? result;
    String? error;
    try {
      result = await request.call();
    } on DioException catch (e) {
      error = e.message;
    } catch (e, st) {
      error = 'Error processing response when receiving $R';
      logger.warning('$runtimeType: $error', e, st);
    }
    return Result<R>(result: result, error: error);
  }
}

final class Result<R> {
  final R? _result;
  final String? _error;

  Result({R? result, String? error}) : _error = error, _result = result;

  void handler({
    required Function(R result) onResult,
    Function(String? error)? onError,
  }) {
    if (_result != null) {
      onResult.call(_result);
    } else if (_error == null && _result == null) {
      onResult.call(_result as R);
    } else {
      onError?.call(_error);
    }
  }

  R? get result => _result;
}
