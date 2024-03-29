// Map<String, Map<String, String>> localizedValues = {
//   'en': {
//     'title': 'Let’s get started',
//     'createAcc': 'CREATE ACCOUNT',
//     'signin': 'SIGN IN',
//     'forgotPass': 'Forgot your account?',
//     'SignIn': 'Sign in',
//   },
//   'fr': {
//     'title': 'Commençons',
//     'createAcc': 'CRÉER UN COMPTE',
//     'signin': 'S\'IDENTIFIER',
//     'forgotPass': 'Vous avez oublié votre compte ?',
//     'SignIn': 'S\'IDENTIFIER',
//   },
// };
import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreferences {
  static const String _key = 'language';

  static Future<void> setLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, languageCode);
  }

  static Future<String> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ??
        'en'; // default to English if no language is set
  }
}
