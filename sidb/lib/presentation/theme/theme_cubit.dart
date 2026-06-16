import 'package:bloc/bloc.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;
import 'app_theme.dart';

enum ThemeMode { light, dark }

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit([super.initialMode = ThemeMode.light]) {
    if (kIsWeb) {
      _loadTheme();
    }
  }

  AppTheme get theme => state == ThemeMode.light ? AppTheme.light : AppTheme.dark;

  void _loadTheme() {
    // Client-only app: localStorage is the single source of truth.
    final savedTheme = web.window.localStorage.getItem('theme');
    if (savedTheme != null) {
      _setModeByName(savedTheme);
    }
  }

  void _setModeByName(String name) {
    final mode = ThemeMode.values.firstWhere(
      (m) => m.name == name,
      orElse: () => ThemeMode.light,
    );
    if (mode != state) {
      emit(mode);
      _updateDocument();
    }
  }

  void updateMode(ThemeMode mode) {
    if (state != mode) {
      emit(mode);
      _updateDocument();
    }
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(newMode);
    if (kIsWeb) {
      web.window.localStorage.setItem('theme', newMode.name);
      _updateDocument();
    }
  }

  void _updateDocument() {
    if (kIsWeb) {
      web.document.documentElement?.setAttribute('data-theme', state.name);
    }
  }
}
