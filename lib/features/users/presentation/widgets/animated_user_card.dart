import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import 'user_card.dart';

class AnimatedUserCard extends StatefulWidget {
  final UserEntity user;
  final bool isUpdated;

  const AnimatedUserCard({
    super.key,
    required this.user,
    this.isUpdated = false,
  });

  @override
  State<AnimatedUserCard> createState() => _AnimatedUserCardState();
}

class _AnimatedUserCardState extends State<AnimatedUserCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.green.withValues(alpha: 0.1),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedUserCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isUpdated && !oldWidget.isUpdated) {
      _controller.reset();
      _controller.forward().then((_) {
        if (mounted) {
          _controller.reverse();
        }
      });
    } else if (!widget.isUpdated && oldWidget.isUpdated) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: _colorAnimation.value,
            ),
            child: UserCard(user: widget.user),
          ),
        );
      },
    );
  }
}