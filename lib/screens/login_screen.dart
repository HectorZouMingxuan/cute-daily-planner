import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../widgets/common/app_notification.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AnimationController _animController;
  late final List<Animation<double>> _entrances;
  bool _isRegistering = false;
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _entrances = List.generate(7, (i) {
      final start = i * .07;
      return CurvedAnimation(
        parent: _animController,
        curve: Interval(start, start + .45, curve: Curves.easeOutCubic),
      );
    });
    _animController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty) {
      AppNotification.error(context, 'Please enter your email');
      return;
    }
    if (password.isEmpty) {
      AppNotification.error(context, 'Please enter your password');
      return;
    }
    if (password.length < 6) {
      AppNotification.error(context, 'Password must be at least 6 characters');
      return;
    }

    setState(() => _loading = true);

    try {
      final controller = ref.read(authControllerProvider);
      if (_isRegistering) {
        await controller.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        await controller.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        AppNotification.error(context, _friendlyMessage(e.code));
      }
    } catch (_) {
      if (mounted) {
        AppNotification.error(
          context,
          'Something went wrong. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyMessage(String code) {
    return switch (code) {
      'invalid-email' => 'Please enter a valid email address.',
      'user-disabled' => 'This account has been disabled.',
      'user-not-found' => 'No account found with this email.',
      'wrong-password' => 'Incorrect password. Please try again.',
      'email-already-in-use' => 'An account with this email already exists.',
      'weak-password' => 'Password must be at least 6 characters.',
      'invalid-credential' => 'Invalid email or password.',
      'network-request-failed' => 'Network error. Check your connection.',
      _ => 'Something went wrong. Please try again.',
    };
  }

  Widget _fadeSlide(int i, Widget child) {
    if (i >= _entrances.length) return child;
    return AnimatedBuilder(
      animation: _entrances[i],
      builder: (_, c) => Opacity(
        opacity: _entrances[i].value,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - _entrances[i].value)),
          child: c,
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
          // Dim overlay
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        const Color(0xFF080C14).withValues(alpha: .82),
                        const Color(0xFF0E1420).withValues(alpha: .7),
                      ]
                    : [
                        const Color(0xFF1F2320).withValues(alpha: .38),
                        const Color(0xFF1F2320).withValues(alpha: .52),
                      ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: AppSpacing.xxl),
                      // Logo
                      _fadeSlide(
                        0,
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: AppColors.primary
                                .withValues(alpha: isDark ? .2 : .18),
                            borderRadius:
                                BorderRadius.circular(AppRadius.xl),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: .35),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            Icons.calendar_month_rounded,
                            size: 44,
                            color: isDark
                                ? AppColors.primary
                                : const Color(0xFFD4A84B),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Title
                      _fadeSlide(
                        1,
                        const Text(
                          'Cute Daily\nPlanner',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.15,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      // Subtitle
                      _fadeSlide(
                        2,
                        Text(
                          _isRegistering
                              ? 'Create your account'
                              : 'Sign in to continue',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: .72),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl + 8),
                      // Email field
                      _fadeSlide(
                        3,
                        _LoginTextField(
                          controller: _emailController,
                          hint: 'Email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm + 4),
                      // Password field
                      _fadeSlide(
                        4,
                        _LoginTextField(
                          controller: _passwordController,
                          hint: 'Password',
                          icon: Icons.lock_outlined,
                          obscure: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          isDark: isDark,
                          onSubmitted: (_) => _submit(),
                          suffix: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Submit button
                      _fadeSlide(
                        5,
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton(
                            onPressed: _loading ? null : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: isDark
                                  ? const Color(0xFF1A1F28)
                                  : const Color(0xFF1F2320),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                              ),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    _isRegistering ? 'Sign Up' : 'Log In',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Toggle
                      _fadeSlide(
                        6,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isRegistering
                                  ? 'Already have an account?'
                                  : "Don't have an account?",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: .65),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  setState(() => _isRegistering = !_isRegistering),
                              style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.only(left: 2, right: 0),
                              ),
                              child: Text(
                                _isRegistering
                                    ? 'Log In'
                                    : 'Create Account',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white38,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.isDark,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.suffix,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isDark;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffix;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: .35),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: Colors.white.withValues(alpha: .22),
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: .6),
            fontSize: 14,
          ),
          prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: .75), size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
