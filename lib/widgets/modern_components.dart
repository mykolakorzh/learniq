import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';

/// Modern gradient button with shadow and haptic feedback
class ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? padding;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = true,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 56,
    this.padding,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      HapticFeedback.lightImpact();
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: widget.onPressed != null && !widget.isLoading
                ? () {
                    HapticFeedback.mediumImpact();
                    widget.onPressed!();
                  }
                : null,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                gradient: widget.isPrimary
                    ? AppTheme.primaryGradient
                    : null,
                color: widget.isPrimary ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: widget.isPrimary
                    ? null
                    : Border.all(color: AppTheme.primaryIndigo, width: 2),
                boxShadow: widget.isPrimary
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryIndigo.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.isPrimary ? Colors.white : AppTheme.primaryIndigo,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                color: widget.isPrimary
                                    ? Colors.white
                                    : AppTheme.primaryIndigo,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              widget.text,
                              style: TextStyle(
                                color: widget.isPrimary
                                    ? Colors.white
                                    : AppTheme.primaryIndigo,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Modern gradient app bar
class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showGradient;
  final Color? backgroundColor;

  const ModernAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showGradient = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: Colors.white,
      leading: leading,
      actions: actions,
      flexibleSpace: showGradient
          ? Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Modern card with consistent styling
class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? color;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(8),
      child: Material(
        color: color ?? AppTheme.surfaceLight,
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        elevation: elevation ?? 8,
        shadowColor: AppTheme.primaryIndigo.withValues(alpha: 0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Modern progress indicator with gradient
class ModernProgressIndicator extends StatelessWidget {
  final double value;
  final double height;
  final Color? backgroundColor;
  final bool showPercentage;
  final String? label;

  const ModernProgressIndicator({
    super.key,
    required this.value,
    this.height = 8,
    this.backgroundColor,
    this.showPercentage = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppTheme.textSecondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(height / 2),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryIndigo),
            ),
          ),
        ),
        if (showPercentage) ...[
          const SizedBox(height: 4),
          Text(
            '${(value * 100).round()}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

/// Gradient background container
class GradientBackground extends StatelessWidget {
  final Widget child;
  final LinearGradient? gradient;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const GradientBackground({
    super.key,
    required this.child,
    this.gradient,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppTheme.primaryGradient,
      ),
      child: child,
    );
  }
}

/// Modern section header
class ModernSectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  const ModernSectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: AppTheme.primaryIndigo,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryIndigo,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Modern loading indicator
class ModernLoadingIndicator extends StatefulWidget {
  final String? message;
  final double size;

  const ModernLoadingIndicator({
    super.key,
    this.message,
    this.size = 40,
  });

  @override
  State<ModernLoadingIndicator> createState() => _ModernLoadingIndicatorState();
}

class _ModernLoadingIndicatorState extends State<ModernLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryIndigo,
                    AppTheme.secondaryPurple,
                  ],
                  stops: [
                    _animation.value,
                    (_animation.value + 0.3).clamp(0.0, 1.0),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.school,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            );
          },
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Article color utilities
class ArticleColors {
  static Color getArticleColor(String article) {
    switch (article.toLowerCase()) {
      case 'der':
        return AppTheme.derColor;
      case 'die':
        return AppTheme.dieColor;
      case 'das':
        return AppTheme.dasColor;
      default:
        return AppTheme.textSecondary;
    }
  }

  static String getArticleEmoji(String article) {
    switch (article.toLowerCase()) {
      case 'der':
        return '🔵';
      case 'die':
        return '🔴';
      case 'das':
        return '🟢';
      default:
        return '⚪';
    }
  }
}

/// Modern error widget
class ModernErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const ModernErrorWidget({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.error_outline,
                size: 40,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ModernButton(
                text: 'Try Again',
                onPressed: onRetry,
                icon: Icons.refresh,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Modern success widget
class ModernSuccessWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onContinue;
  final IconData? icon;

  const ModernSuccessWidget({
    super.key,
    required this.title,
    required this.message,
    this.onContinue,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? Icons.check_circle,
                size: 40,
                color: AppTheme.accentGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onContinue != null) ...[
              const SizedBox(height: 24),
              ModernButton(
                text: 'Continue',
                onPressed: onContinue,
                icon: Icons.arrow_forward,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
