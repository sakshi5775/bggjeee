class SignUpModel {
  bool? success;
  String? message;
  User? user;
  String? accessToken;
  String? refreshToken;

  SignUpModel({
    this.success,
    this.message,
    this.user,
    this.accessToken,
    this.refreshToken,
  });

  SignUpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] == true;
    message = json['message']?.toString();
    
    // Handle nested data structure from API response
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      user = data['user'] != null ? User.fromJson(data['user'] as Map<String, dynamic>) : null;
      accessToken = data['accessToken']?.toString();
      refreshToken = data['refreshToken']?.toString();
    } else {
      // Fallback for direct structure (backward compatibility)
      user = json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null;
      accessToken = json['accessToken']?.toString();
      refreshToken = json['refreshToken']?.toString();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    return data;
  }
}

class User {
  String? userId;
  String? phone;
  String? email;
  String? username;
  String? userType;

  User({this.userId, this.phone, this.email, this.username, this.userType});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    phone = json['phone'];
    email = json['email'];
    username = json['username'];
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['phone'] = phone;
    data['email'] = email;
    data['username'] = username;
    data['userType'] = userType;
    return data;
  }
}
