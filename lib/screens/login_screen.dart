import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _animController;
  late final List<Animation<double>> _entrances;
  bool _isRegistering = false;
  bool _loading = false;
  bool _obscurePassword = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entrances = List.generate(7, (i) {
      final start = i * 0.10;
      return CurvedAnimation(
        parent: _animController,
        curve: Interval(start, start + 0.4, curve: Curves.easeOutCubic),
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
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorText = null;
    });

    try {
      final controller = ref.read(authControllerProvider);
      if (_isRegistering) {
        await controller.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await controller.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorText = _friendlyMessage(e.code));
    } catch (e) {
      setState(() => _errorText = 'Something went wrong. Please try again.');
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

  Widget _buildAnimated(int index, Widget child) {
    if (index >= _entrances.length) return child;
    return AnimatedBuilder(
      animation: _entrances[index],
      builder: (context, child) {
        return Opacity(
          opacity: _entrances[index].value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - _entrances[index].value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(color: AppColors.dimOverlay),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildAnimated(0, _LogoIcon()),
                      const SizedBox(height: AppSpacing.lg),
                      _buildAnimated(1, const _TitleText()),
                      const SizedBox(height: AppSpacing.sm),
                      _buildAnimated(
                        2,
                        _SubtitleText(isRegistering: _isRegistering),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _buildAnimated(
                        3,
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(color: AppColors.ink),
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildAnimated(
                        4,
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          style: TextStyle(color: AppColors.ink),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _submit(),
                        ),
                      ),
                      if (_errorText != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        _buildAnimated(
                          5,
                          Text(
                            _errorText!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.danger,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _buildAnimated(6, _AuthButton(loading: _loading, onPressed: _submit, isRegistering: _isRegistering)),
                      ] else ...[
                        const SizedBox(height: AppSpacing.md),
                        _buildAnimated(5, _AuthButton(loading: _loading, onPressed: _submit, isRegistering: _isRegistering)),
                        const SizedBox(height: AppSpacing.sm),
                        _buildAnimated(
                          6,
                          _ToggleText(
                            isRegistering: _isRegistering,
                            onTap: () => setState(() {
                              _isRegistering = !_isRegistering;
                              _errorText = null;
                            }),
                          ),
                        ),
                      ],
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

class _LogoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primarySoft.withValues(alpha: .85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.calendar_month_rounded,
        size: 40,
        color: AppColors.ink,
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Cute Daily Planner',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: Colors.white,
      ),
    );
  }
}

class _SubtitleText extends StatelessWidget {
  const _SubtitleText({required this.isRegistering});

  final bool isRegistering;

  @override
  Widget build(BuildContext context) {
    return Text(
      isRegistering ? 'Create your account' : 'Sign in to continue',
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.loading,
    required this.onPressed,
    required this.isRegistering,
  });

  final bool loading;
  final VoidCallback onPressed;
  final bool isRegistering;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(isRegistering ? 'Sign Up' : 'Log In'),
      ),
    );
  }
}

class _ToggleText extends StatelessWidget {
  const _ToggleText({required this.isRegistering, required this.onTap});

  final bool isRegistering;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        isRegistering
            ? 'Already have an account? Log In'
            : "Don't have an account? Sign Up",
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
