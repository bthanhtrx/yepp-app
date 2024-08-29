import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPref._privateConstructor();
  static final SharedPref instance = SharedPref._privateConstructor();

  static SharedPreferences? _sharedPreferences;

  Future<SharedPreferences> get sharedPref async {
    if(_sharedPreferences != null) return _sharedPreferences!;

    _sharedPreferences = await _initSharedPref();
    return _sharedPreferences!;
  }

  Future<SharedPreferences> _initSharedPref() async{
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences!;
  }

  Future<bool> get isDarkMode async {
    final db = await instance.sharedPref;
    return db.getBool('is_dark_mode') ?? false;
  }

  Future<bool> setDarkMode(bool isDark) async {
    final db = await instance.sharedPref;
    return await db.setBool('is_dark_mode', isDark);
  }
}