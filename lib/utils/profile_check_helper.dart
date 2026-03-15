import 'package:astrobharataiuser/app_manager/user_data.dart';
import 'package:astrobharataiuser/data_model/user_profile_model.dart';
import 'package:astrobharataiuser/screens/user_dashboard/service/user_profile_service.dart';

/// Helper class to check user profile completeness and wallet balance
class ProfileCheckHelper {
  final UserProfileService _profileService = UserProfileService();
  final UserData _userData = UserData();

  /// Check if profile is complete
  /// Returns true if all required fields are filled
  Future<bool> isProfileComplete() async {
    try {
      final userId = _userData.getLoginData.user?.userId;
      if (userId == null) return false;

      final profile = await _profileService.getProfile(userId);
      if (profile == null) return false;

      // Check personal info
      final personalInfo = profile.personalInfo;
      if (personalInfo == null) return false;
      if (personalInfo.fullName == null || personalInfo.fullName!.isEmpty) return false;
      if (personalInfo.gender == null || personalInfo.gender!.isEmpty) return false;
      if (personalInfo.maritalStatus == null || personalInfo.maritalStatus!.isEmpty) return false;
      if (personalInfo.occupation == null || personalInfo.occupation!.isEmpty) return false;

      // Check birth chart
      final birthChart = profile.birthChart;
      if (birthChart == null) return false;
      if (birthChart.birthPlace == null) return false;
      if (birthChart.birthPlace!.city == null || birthChart.birthPlace!.city!.isEmpty) return false;
      if (birthChart.birthTime == null) return false;
      if (birthChart.birthTime!.hour == null || birthChart.birthTime!.minute == null) return false;

      return true;
    } catch (e) {
      print('Error checking profile completeness: $e');
      return false;
    }
  }

  /// Get user profile
  Future<UserProfileModel?> getUserProfile() async {
    try {
      final userId = _userData.getLoginData.user?.userId;
      if (userId == null) return null;

      return await _profileService.getProfile(userId);
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Check if email and phone are verified
  Future<bool> areContactDetailsVerified() async {
    try {
      final user = _userData.getLoginData.user;
      if (user == null) return false;

      final emailVerified = user.emailVerified ?? false;
      final phoneVerified = user.phoneVerified ?? false;

      return emailVerified && phoneVerified;
    } catch (e) {
      print('Error checking contact verification: $e');
      return false;
    }
  }

  /// Get email and phone verification status
  Future<Map<String, dynamic>> getContactVerificationStatus() async {
    try {
      final user = _userData.getLoginData.user;
      if (user == null) {
        return {'emailVerified': false, 'phoneVerified': false, 'email': '', 'phone': ''};
      }

      return {
        'emailVerified': user.emailVerified ?? false,
        'phoneVerified': user.phoneVerified ?? false,
        'email': user.email ?? '',
        'phone': user.phone ?? '',
      };
    } catch (e) {
      print('Error getting contact verification status: $e');
      return {'emailVerified': false, 'phoneVerified': false, 'email': '', 'phone': ''};
    }
  }

  /// Check wallet balance
  /// Returns wallet balance or 0.0 if not available
  Future<double> getWalletBalance() async {
    try {
      final profile = await getUserProfile();
      if (profile?.wallet == null) return 0.0;
      return profile!.wallet!.balance ?? 0.0;
    } catch (e) {
      print('Error getting wallet balance: $e');
      return 0.0;
    }
  }

  /// Check if wallet balance is sufficient for a given amount
  Future<bool> isWalletBalanceSufficient(double requiredAmount) async {
    final balance = await getWalletBalance();
    return balance >= requiredAmount;
  }

  /// Get minimum wallet balance required for astrologer/persona.
  /// - For Persona AI (estimatedMinutes=1): require pricePerMinute * 1 per doc.
  /// - For astrologers: require 2x the estimated cost as buffer.
  double getMinimumRequiredBalance(double pricePerMinute, {int estimatedMinutes = 15}) {
    if (estimatedMinutes <= 1) {
      return pricePerMinute * 1;
    }
    return pricePerMinute * estimatedMinutes * 2;
  }
}


