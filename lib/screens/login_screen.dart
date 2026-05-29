import 'package:flutter/material.dart';

import 'calendar_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  late final AnimationController _animController;
  late final List<Animation<double>> _entrances;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entrances = List.generate(5, (i) {
      final start = i * 0.12;
      return CurvedAnimation(
        parent: _animController,
        curve: Interval(start, start + 0.4, curve: Curves.easeOutCubic),
      );
    });
    _animController.forward();
  }

  void _login() {
    final username = _controller.text.trim();
    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a username')),
      );
      return;
    }
    Navigator.of(context).pushReplacement(_createRoute(username));
  }

  Route _createRoute(String username) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: CalendarScreen(username: username),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  Widget _buildAnimated(int index, Widget child) {
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
            decoration: BoxDecoration(
              color: AppColors.dimOverlay,
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAnimated(0, _LogoIcon()),
                    const SizedBox(height: AppSpacing.lg),
                    _buildAnimated(1, const _TitleText()),
                    const SizedBox(height: AppSpacing.sm),
                    _buildAnimated(2, const _SubtitleText()),
                    const SizedBox(height: AppSpacing.xl),
                    _buildAnimated(3, _TextFieldRow(controller: _controller, onSubmitted: _login)),
                    const SizedBox(height: AppSpacing.md),
                    _buildAnimated(4, _ContinueButton(onPressed: _login)),
                  ],
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
  const _SubtitleText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Enter your name to get started',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white70,
      ),
    );
  }
}

class _TextFieldRow extends StatelessWidget {
  const _TextFieldRow({required this.controller, required this.onSubmitted});

  final TextEditingController controller;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style:  TextStyle(color: AppColors.ink),
      decoration: const InputDecoration(
        hintText: 'Your username',
        prefixIcon: Icon(Icons.person_outline_rounded),
      ),
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => onSubmitted(),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        child: const Text('Continue'),
      ),
    );
  }
}
