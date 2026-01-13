class UserProfile {
  UserProfile({
    this.userId,
    this.username,
    this.email,
    this.phone,
    this.userType,
    this.role,
    this.profileImage,
    bool? emailVerified,
    bool? phoneVerified,
    bool? isActive,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
  })  : emailVerified = emailVerified ?? false,
        phoneVerified = phoneVerified ?? false,
        isActive = isActive ?? false;

  UserProfile.fromJson(Map<String, dynamic> json)
      : emailVerified = json['emailVerified'] == true,
        phoneVerified = json['phoneVerified'] == true,
        isActive = json['isActive'] == true {
    userId = json['userId']?.toString();
    username = json['username']?.toString();
    email = json['email']?.toString();
    phone = json['phone']?.toString();
    userType = json['userType']?.toString();
    role = json['role']?.toString();
    profileImage = json['profileImage']?.toString();
    lastLogin = json['lastLogin']?.toString();
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  String? userId;
  String? username;
  String? email;
  String? phone;
  String? userType;
  String? role;
  String? profileImage;
  bool emailVerified;
  bool phoneVerified;
  bool isActive;
  String? lastLogin;
  String? createdAt;
  String? updatedAt;
}

class UserProfileResponse {
  UserProfileResponse({
    bool? success,
    this.message,
    this.profile,
  }) : success = success ?? false;

  UserProfileResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'] == true {
    message = json['message']?.toString();
    if (json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      if (data['user'] is Map<String, dynamic>) {
        profile = UserProfile.fromJson(data['user'] as Map<String, dynamic>);
      }
    }
  }

  bool success;
  String? message;
  UserProfile? profile;
}
