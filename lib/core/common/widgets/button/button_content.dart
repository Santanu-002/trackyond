part of 'app_button.dart';

class _AppButtonContent extends StatelessWidget {
  final String? text;
  final Widget? child;
  final AppButtonType type;
  final Color? color;
  final Widget? leading;
  final bool isLoading;

  const _AppButtonContent({
    this.text,
    required this.type,
    this.color,
    this.child,
    this.leading,
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
    if (child != null || leading != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leading != null) ...[
            IconTheme.merge(
              data: IconThemeData(
                size: 20,
                color: _getTextColor(context),
              ),
              child: leading!,
            ),
            AppUIConstants.widgets.horizontalBox$8,
          ],
          if (child != null)
            child!
          else
            Text(
              text ?? '',
              style: context.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getTextColor(context),
              ),
            ),
        ],
      );
    }

    return Text(
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
