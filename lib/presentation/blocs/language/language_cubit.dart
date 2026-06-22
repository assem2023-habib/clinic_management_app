import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  static const _key = 'app_locale';
  static LanguageCubit? _instance;

  LanguageCubit() : super(const Locale('ar')) {
    _instance = this;
    _loadLocale();
  }

  static Locale get currentLocale => _instance?.state ?? const Locale('ar');

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key) ?? 'ar';
    if (!isClosed) emit(Locale(code));
  }

  Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, languageCode);
    if (!isClosed) emit(Locale(languageCode));
  }
}
