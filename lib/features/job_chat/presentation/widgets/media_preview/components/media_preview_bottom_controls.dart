import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trackyond/core/common/enums/media_preview_type.dart';
import 'package:trackyond/core/constants/app_strings.dart';
import 'package:trackyond/core/constants/app_ui_constants.dart';
import 'package:trackyond/core/theme/color_scheme_extension.dart';
import 'package:trackyond/features/job_chat/presentation/controllers/job_chat_controller.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/chat_input_field.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/input/chat_send_button.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/add_more_button.dart';
import 'package:trackyond/features/job_chat/presentation/widgets/media_preview/thumbnail_item.dart';

class MediaPreviewBottomControls extends StatefulWidget {
  final TextEditingController captionController;
  final FocusNode focusNode;
  final bool isKeyboardActive;
  final List<String> mediaPaths;
  final int currentIndex;
  final bool isLoading;
  final MediaPreviewType previewType;
  final VoidCallback onSend;
  final VoidCallback onPickMoreMedia;
  final ValueChanged<int> onThumbnailTap;

  const MediaPreviewBottomControls({
    super.key,
    required this.captionController,
    required this.focusNode,
    required this.isKeyboardActive,
    required this.mediaPaths,
    required this.currentIndex,
    required this.isLoading,
    required this.previewType,
    required this.onSend,
    required this.onPickMoreMedia,
    required this.onThumbnailTap,
  });

  @override
  State<MediaPreviewBottomControls> createState() => _MediaPreviewBottomControlsState();
}

class _MediaPreviewBottomControlsState extends State<MediaPreviewBottomControls> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(widget.currentIndex);
    });
  }

  @override
  void didUpdateWidget(covariant MediaPreviewBottomControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex ||
        widget.mediaPaths.length != oldWidget.mediaPaths.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToIndex(widget.currentIndex);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;

    final viewportWidth = _scrollController.position.viewportDimension;
    final maxScrollExtent = _scrollController.position.maxScrollExtent;

    const itemWidth = 64.0;
    const padding = 16.0;
    final targetOffset = (index * itemWidth) + padding - (viewportWidth / 2) + (itemWidth / 2);
    final clampedOffset = targetOffset.clamp(0.0, maxScrollExtent);

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final controller = Get.find<JobChatController>();

    return Positioned(
      bottom: context.mediaQueryViewInsets.bottom,
      left: 0,
      right: 0,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 56,
              margin: EdgeInsets.only(
                bottom: AppUIConstants.spacing.space$12,
              ),
              child: AnimatedOpacity(
                opacity: widget.isKeyboardActive ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppUIConstants.spacing.space$16,
                  ),
                  itemCount: widget.mediaPaths.length + 1,
                  itemBuilder: (context, index) {
                    if (index == widget.mediaPaths.length) {
                      return AddMoreButton(
                        isLoading: widget.isLoading,
                        colorScheme: colorScheme,
                        onTap: widget.onPickMoreMedia,
                      );
                    }
                    return ThumbnailItem(
                      index: index,
                      path: widget.mediaPaths[index],
                      isActive: index == widget.currentIndex,
                      isLoading: widget.isLoading,
                      colorScheme: colorScheme,
                      previewType: widget.previewType,
                      onTap: () => widget.onThumbnailTap(index),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppUIConstants.spacing.space$16,
              ),
              child: ChatInputField(
                controller: widget.captionController,
                focusNode: widget.focusNode,
                hintText: AppStrings.jobChat.addCaptionHint,
                backgroundColor: colorScheme.black,
                borderColor: colorScheme.onPrimary.withValues(
                  alpha: 0.2,
                ),
                textColor: colorScheme.onPrimary,
                hintColor: colorScheme.onPrimary.withValues(
                  alpha: 0.5,
                ),
              ),
            ),
            AppUIConstants.widgets.verticalBox$12,
            Container(
              padding: EdgeInsets.fromLTRB(
                AppUIConstants.spacing.space$16,
                AppUIConstants.spacing.space$16,
                AppUIConstants.spacing.space$16,
                AppUIConstants.spacing.space$24,
              ),
              decoration: BoxDecoration(
                color: colorScheme.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(
                    AppUIConstants.radius.radius$32,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppUIConstants.spacing.space$16,
                      vertical: AppUIConstants.spacing.space$8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary.withValues(
                        alpha: 0.15,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppUIConstants.radius.radius$12,
                      ),
                    ),
                    child: Text(
                      '${AppStrings.jobChat.jobIdPrefix}${controller.job.jobId}',
                      style: context.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ChatSendButton(
                    onPressed: widget.onSend,
                    isLoading: widget.isLoading,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
