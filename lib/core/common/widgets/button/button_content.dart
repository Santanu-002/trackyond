part of 'app_button.dart';

class _AppButtonContent extends StatelessWidget {
  final String? text;
  final Widget? child;
  final AppButtonType type;
  final Color? color;
  final bool isLoading;

  const _AppButtonContent({
    this.text,
    required this.type,
    this.color,
    this.child,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: _getTextColor(context),
        ),
      );
    }
    return child ??
        Text(
          text ?? '',
          style: context.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: _getTextColor(context),
          ),
        );
  }

  Color _getTextColor(BuildContext context) {
    if (type == AppButtonType.filled) return context.theme.colorScheme.onPrimary;
    return color ?? context.theme.colorScheme.primary;
  }
}
