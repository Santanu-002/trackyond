part of 'app_button.dart';

class _OutlinedAppButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final Color? color;
  final double? borderRadius;
  final bool isLoading;

  const _OutlinedAppButton({
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
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: color ?? context.theme.colorScheme.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(borderRadius: radius),
          foregroundColor: color ?? context.theme.colorScheme.primary,
        ),
        child: _AppButtonContent(
          text: text,
          type: AppButtonType.outlined,
          color: color,
          isLoading: isLoading,
          child: child,
        ),
      ),
    );
  }
}
