enum UserRole {
  user('USER');

  const UserRole(this.value);
  final String value;

  static UserRole fromString(String role) {
    // Always return user role since this is a user-only app
    return UserRole.user;
  }

  String get displayName {
    return 'User';
  }

  String get dashboardRoute {
    return '/user-dashboard';
  }
}
