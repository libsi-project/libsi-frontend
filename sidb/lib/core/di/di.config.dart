// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:sidb/presentation/features/pack/repository/pack_repository.dart'
    as _i893;
import 'package:sidb/presentation/features/pack/usecase/pack_usecase.dart'
    as _i295;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i893.PackRepository>(
      () => _i893.ApiPackRepository(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i295.PackUseCase>(
      () => _i295.PackUseCase(gh<_i893.PackRepository>()),
    );
    return this;
  }
}
