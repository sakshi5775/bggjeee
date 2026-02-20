class LoginModel {
  User? user;
  String? accessToken;
  String? refreshToken;

  LoginModel({this.user, this.accessToken, this.refreshToken});

  LoginModel.fromJson(Map<String, dynamic> json) {
    // Handle nested data structure from API response
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      user = data['user'] != null ? new User.fromJson(data['user']) : null;
      accessToken = data['accessToken'];
      refreshToken = data['refreshToken'];
    } else {
      // Fallback for direct structure (backward compatibility)
      user = json['user'] != null ? new User.fromJson(json['user']) : null;
      accessToken = json['accessToken'];
      refreshToken = json['refreshToken'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    return data;
  }
}

class User {
  String? userId;
  String? username;
  String? email;
  String? phone;
  String? userType;
  String? role;
  bool? phoneVerified;
  bool? emailVerified;
  String? lastLogin;

  User({
    this.userId,
    this.username,
    this.email,
    this.phone,
    this.userType,
    this.role,
    this.phoneVerified,
    this.emailVerified,
    this.lastLogin,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId']?.toString() ?? json['id']?.toString();
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    userType = json['userType'];
    role = json['role'];
    phoneVerified = json['phoneVerified'];
    emailVerified = json['emailVerified'];
    lastLogin = json['lastLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['userType'] = this.userType;
    data['role'] = this.role;
    data['phoneVerified'] = this.phoneVerified;
    data['emailVerified'] = this.emailVerified;
    data['lastLogin'] = this.lastLogin;
    return data;
  }
}
