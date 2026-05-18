part of 'app_button.dart';

class _FilledAppButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Widget? leading;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;
  final List<Color>? gradientColors;
  final Color? splashColor;
  final AppButtonShape shape;
  final bool isLoading;

  const _FilledAppButton({
    super.key,
    this.text,
    this.child,
    this.leading,
    this.onPressed,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.gradientColors,
    this.splashColor,
    required this.shape,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final radius = _getBorderRadius(shape, borderRadius);
    final List<Color> colors = gradientColors ??
        [
          color ?? context.theme.colorScheme.primary,
          color ?? context.theme.colorScheme.primaryContainer,
        ];

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: const GradientRotation(2.35619), // 135 degrees
        ),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: radius),
          overlayColor: splashColor,
        ),
        child: _AppButtonContent(
          text: text,
          type: AppButtonType.filled,
          color: color,
          leading: leading,
          isLoading: isLoading,
          child: child,
        ),
      ),
    );
  }
}
