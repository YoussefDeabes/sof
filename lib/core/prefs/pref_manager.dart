import 'package:sof/core/prefs/pref_keys.dart';
import 'package:sof/core/prefs/pref_util.dart';

class PrefManager {
  static Future<bool> setBookmarkedUsers(List<String> userIds) async {
    return await PrefUtils.setStringList(PrefKeys.bookmarkedUsers, userIds);
  }

  static Future<List<String>> getBookmarkedUsers() async {
    return await PrefUtils.getStringList(PrefKeys.bookmarkedUsers) ?? [];
  }

  static Future<bool> setLang(String? data) async {
    return await PrefUtils.setString(PrefKeys.lang, data!);
  }

  static Future<String?> getLang() async {
    return await PrefUtils.getString(PrefKeys.lang);
  }

  static Future<void> clearAllData() async {
    await PrefUtils.clearData();
  }
}

