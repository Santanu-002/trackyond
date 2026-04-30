part of 'app_button.dart';

class _GhostAppButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Widget? leading;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final double? borderRadius;
  final AppButtonShape shape;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final VisualDensity? visualDensity;

  const _GhostAppButton({
    super.key,
    this.text,
    this.child,
    this.leading,
    this.onPressed,
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    required this.shape,
    this.isLoading = false,
    this.padding,
    this.visualDensity,
  });

  @override
  Widget build(BuildContext context) {
    final radius = _getBorderRadius(shape, borderRadius);

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: radius),
          foregroundColor: color ?? context.theme.colorScheme.primary,
          padding: padding,
          visualDensity: visualDensity,
        ),
        child: _AppButtonContent(
          text: text,
          type: AppButtonType.ghost,
          color: color,
          leading: leading,
          isLoading: isLoading,
          child: child,
        ),
      ),
    );
  }
}
