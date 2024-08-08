import 'package:cloud_firestore/cloud_firestore.dart';

class UserPreferencesService {
  final CollectionReference _userPreferences =
  FirebaseFirestore.instance.collection('user_preferences');

  // Update user's dark mode preference
  Future<void> updateUserDarkModePreference(String userId, bool isDarkMode) async {
    await _userPreferences.doc(userId).set({
      '_isDarkMode': isDarkMode,
    }, SetOptions(merge: true));
  }

  // Retrieve user's dark mode preference
  Future<bool> getUserDarkModePreference(String userId) async {
    try {
      DocumentSnapshot userDoc = await _userPreferences.doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
        if (userData != null && userData.containsKey('_isDarkMode')) {
          return userData['_isDarkMode'] ?? false;
        } else {
          // If preference not found or is in wrong format, set it to false (light mode)
          await updateUserDarkModePreference(userId, false);
          return false;
        }
      } else {
        // If document does not exist, create it with default value (false for light mode)
        await updateUserDarkModePreference(userId, false);
        return false;
      }
    } catch (e) {
      print('Error retrieving user preference: $e');
      return false; // Default to light mode in case of error
    }
  }
}
