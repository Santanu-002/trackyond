part of 'app_button.dart';

class _IconAppButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;
  final Color? iconColor;
  final double? borderRadius;
  final String? tooltip;

  const _IconAppButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 40,
    this.color,
    this.iconColor,
    this.borderRadius,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.theme.colorScheme.surfaceContainerHighest;
    final effectiveIconColor = iconColor ?? context.theme.colorScheme.primary;
    
    return IconButton.filled(
      onPressed: onPressed,
      icon: icon,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: effectiveColor,
        foregroundColor: effectiveIconColor,
        minimumSize: Size(size, size),
        fixedSize: Size(size, size),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppUIConstants.radius.radius$12,
          ),
        ),
      ),
    );
  }
}
