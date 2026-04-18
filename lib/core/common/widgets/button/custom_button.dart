part of 'app_button.dart';

class _CustomAppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final Color? color;
  final double? borderRadius;

  const _CustomAppButton({
    super.key,
    required this.child,
    this.onPressed,
    required this.width,
    required this.height,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? 9999);

    return SizedBox(
      width: width,
      height: height,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        child: Center(child: child),
      ),
    );
  }
}
