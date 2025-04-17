// import 'package:hive/hive.dart';

// class DBKeys {
//   static const String dbNAME = 'HappinestDatabase';
//   static const String boxNAME = 'Happinest';
//   static const String eventData = 'eventData';
// }

// class DatabaseManager {
//   // Private constructor
//   DatabaseManager._internal();

//   // The one and only instance of DatabaseManager
//   static final DatabaseManager _instance = DatabaseManager._internal();

//   // Factory constructor to provide the single instance
//   factory DatabaseManager() {
//     return _instance;
//   }
//   // Open the box where your data is stored
//   final Box _userBox = Hive.box(DBKeys.boxNAME);

//   // Save an object in the Hive box
//   Future<void> saveObject(String key, dynamic value) async {
//     await _userBox.put(key, value);
//   }

//   // Read an object from the Hive box
//   dynamic getObject(String key) {
//     return _userBox.get(key);
//   }

//   // Update an object in the Hive box
//   Future<void> updateObject(String key, dynamic value) async {
//     await _userBox.put(key, value);
//   }

//   // Delete an object from the Hive box
//   Future<void> deleteObject(String key) async {
//     await _userBox.delete(key);
//   }

//   // Clear the entire box (for logout or clearing data)
//   Future<void> clearDatabase() async {
//     await _userBox.clear();
//   }
// }
import 'package:hive/hive.dart';

class DBKeys {
  static const String dbNAME = 'HappinestDatabase';
  static const String boxNAME = 'Happinest';
  static const String eventData = 'eventData';
  static const String lastSyncTime = 'lastSyncTime'; // Key for storing last sync time
}

class DatabaseManager {
  // Private constructor
  DatabaseManager._internal();
  // Singleton instance
  static final DatabaseManager _instance = DatabaseManager._internal();
  // Factory constructor
  factory DatabaseManager() {
    return _instance;
  }

  // Open the box where your data is stored
  final Box _userBox = Hive.box(DBKeys.boxNAME);

  // Save an object in the Hive box
  Future<void> saveObject(String key, dynamic value) async {
    await _userBox.put(key, value);
  }

  // Read an object from the Hive box
  dynamic getObject(String key) {
    return _userBox.get(key);
  }

  // Update an object in the Hive box
  Future<void> updateObject(String key, dynamic value) async {
    await _userBox.put(key, value);
  }

  // Delete an object from the Hive box
  Future<void> deleteObject(String key) async {
    await _userBox.delete(key);
  }

  // Clear the entire box (for logout or clearing data)
  Future<void> clearDatabase() async {
    await _userBox.clear();
  }

  /// Save the last sync time
  Future<void> updateLastSyncTime() async {
    await _userBox.put(DBKeys.lastSyncTime, DateTime.now().toIso8601String());
  }

  /// Get the last sync time
  DateTime? getLastSyncTime() {
    String? lastSyncString = _userBox.get(DBKeys.lastSyncTime);
    if (lastSyncString != null) {
      return DateTime.parse(lastSyncString);
    }
    return null;
  }

  /// Get remaining time until the next sync (Assuming sync happens every 24 hours)
  Duration getTimeUntilNextSync() {
    DateTime? lastSync = getLastSyncTime();
    if (lastSync == null) {
      return Duration.zero; // No sync done yet, should sync immediately
    }

    DateTime nextSyncTime = lastSync.add(const Duration(hours: 24));
    Duration remainingTime = nextSyncTime.difference(DateTime.now());
    return remainingTime.isNegative ? Duration.zero : remainingTime;
  }

  /// Get a formatted string of the remaining time
  String getFormattedTimeUntilNextSync() {
    Duration remainingTime = getTimeUntilNextSync();

    if (remainingTime == Duration.zero) {
      return "Sync due now";
    }
    int hours = remainingTime.inHours;
    int minutes = remainingTime.inMinutes.remainder(60);
    int seconds = remainingTime.inSeconds.remainder(60);

    return "$hours hours, $minutes minutes, $seconds seconds until next sync";
  }
}
