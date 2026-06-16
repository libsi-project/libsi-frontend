import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'di.config.dart';
import 'package:injectable/injectable.dart';

const _baseUrl = 'https://69a708632cd1d055268fac16.mockapi.io/api';
final getIt = GetIt.instance;
bool _isDiConfigured = false;

@injectableInit
Future<void> configureDependencies() async {
  if (_isDiConfigured) return;
  getIt.init();
  //TODO check if this check really needed (was needed for SSR)
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerSingleton<Dio>(
      Dio(
          BaseOptions(
            baseUrl: _baseUrl,
          ),
        )
        ..interceptors.addAll(
          //TODO add interceptors: error catching, maybe token?, logging
          [],
        ),
    );
  }
  _isDiConfigured = true;
}
