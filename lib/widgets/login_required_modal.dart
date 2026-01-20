import 'package:astrobharataiuser/app_manager/my_text_field.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/services/guest_session_manager.dart';
import 'package:astrobharataiuser/screens/login/login/service/login_service.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/app_manager/user_data.dart';

/// Login Required Modal Widget
/// Shows when guest user tries to access protected features
class LoginRequiredModal extends StatefulWidget {
  final String? message;
  final VoidCallback? onLoginSuccess;

  const LoginRequiredModal({
    super.key,
    this.message,
    this.onLoginSuccess,
  });

  @override
  State<LoginRequiredModal> createState() => _LoginRequiredModalState();
}

class _LoginRequiredModalState extends State<LoginRequiredModal> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _loginService = LoginService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        Get.snackbar(
          'Error',
          'Please enter email and password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final loginModel = await _loginService.login(email, password);

      if (loginModel != null) {
        // Save user data
        UserData().addLoginData(loginModel.toJson());

        // Disable guest mode
        await GuestSessionManager.disableGuestMode();

        // Close the modal
        Get.back();

        // Show success message
        Get.snackbar(
          'Success',
          'Login successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Call onLoginSuccess callback if provided
        if (widget.onLoginSuccess != null) {
          widget.onLoginSuccess!();
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Login failed. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _navigateToSignup() {
    Get.back();
    Get.toNamed(AppRoutes.signup);
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.deepOrangemix.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: AppColors.deepOrangemix,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                AutoTranslateText(
                  'Login Required',
                  style: MyTextTheme.largeBCB.copyWith(
                    color: AppColors.deepOrangemix,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Message
                AutoTranslateText(
                  widget.message ??
                      'Please login to continue using this feature.',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: AppColors.gray,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Email Field
                MyTextField(
                  controller: _emailController,
                  headerText: 'Email Address',
                  hintText: 'Enter your email',
                  maxLine: 1,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: _validateEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password Field
                MyTextField(
                  controller: _passwordController,
                  headerText: 'Password',
                  hintText: 'Enter your password',
                  isPasswordField: true,
                  prefixIcon: const Icon(Icons.lock_outline),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 24),

                // Login Button
                GestureDetector(
                  onTap: _isLoading ? null : _handleLogin,
                  child: Container(
                    height: 52,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFF38B3B), // light orange
                          Color(0xFFDD2914), // deep orange/red
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.45),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Signup Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoTranslateText(
                      "Already haven't account? ",
                      style: MyTextTheme.smallBCN.copyWith(
                        color: AppColors.gray,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: _navigateToSignup,
                      child: AutoTranslateText(
                        'Signup',
                        style: MyTextTheme.smallBCB.copyWith(
                          color: AppColors.deepOrangemix,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Cancel Button
                TextButton(
                  onPressed: () => Get.back(),
                  child: AutoTranslateText(
                    'Maybe Later',
                    style: MyTextTheme.smallBCB.copyWith(
                      color: AppColors.gray,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
