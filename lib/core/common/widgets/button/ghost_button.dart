part of 'app_button.dart';

class _GhostAppButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final Color? color;
  final double? borderRadius;
  final bool isLoading;

  const _GhostAppButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    required this.width,
    required this.height,
    this.color,
    this.borderRadius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? 9999);

    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: radius),
          foregroundColor: color ?? context.theme.colorScheme.primary,
        ),
        child: _AppButtonContent(
          text: text,
          type: AppButtonType.ghost,
          color: color,
          isLoading: isLoading,
          child: child,
        ),
      ),
    );
  }
}
