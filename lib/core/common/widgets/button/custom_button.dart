part of 'app_button.dart';

class _CustomAppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final Color? color;
  final double? borderRadius;
  final AppButtonShape shape;

  const _CustomAppButton({
    super.key,
    required this.child,
    this.onPressed,
    required this.width,
    required this.height,
    this.color,
    this.borderRadius,
    required this.shape,
  });

  @override
  Widget build(BuildContext context) {
    final radius = _getBorderRadius(shape, borderRadius);

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
