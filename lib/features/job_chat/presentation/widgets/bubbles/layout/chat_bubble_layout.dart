import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatBubbleLayout extends MultiChildRenderObjectWidget {
  ChatBubbleLayout({
    super.key,
    required Widget text,
    required Widget time,
  }) : super(children: [text, time]);

  @override
  RenderChatBubbleLayout createRenderObject(BuildContext context) {
    return RenderChatBubbleLayout();
  }
}

class ChatBubbleLayoutParentData extends ContainerBoxParentData<RenderBox> {}

class RenderChatBubbleLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, ChatBubbleLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, ChatBubbleLayoutParentData> {
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! ChatBubbleLayoutParentData) {
      child.parentData = ChatBubbleLayoutParentData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final textChild = firstChild!;
    final timeChild = lastChild!;
    return max(
      textChild.getMinIntrinsicWidth(height),
      timeChild.getMinIntrinsicWidth(height),
    );
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final textChild = firstChild!;
    final timeChild = lastChild!;
    final spacing = 8.0;
    return textChild.getMaxIntrinsicWidth(height) + spacing + timeChild.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final textChild = firstChild!;
    final timeChild = lastChild!;
    return textChild.getMinIntrinsicHeight(width) + timeChild.getMinIntrinsicHeight(width);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final textChild = firstChild!;
    final timeChild = lastChild!;
    return textChild.getMaxIntrinsicHeight(width) + timeChild.getMaxIntrinsicHeight(width);
  }

  @override
  void performLayout() {
    final textChild = firstChild!;
    final timeChild = lastChild!;

    // 1. Layout the text child
    textChild.layout(
      BoxConstraints(
        minWidth: 0,
        maxWidth: constraints.maxWidth,
      ),
      parentUsesSize: true,
    );

    // 2. Layout the time child
    timeChild.layout(
      const BoxConstraints(minWidth: 0, minHeight: 0),
      parentUsesSize: true,
    );

    final textSize = textChild.size;
    final timeSize = timeChild.size;

    double lastLineWidth = textSize.width;

    if (textChild is RenderParagraph) {
      final textPainter = TextPainter(
        text: textChild.text,
        textDirection: textChild.textDirection,
        maxLines: textChild.maxLines,
        textAlign: textChild.textAlign,
        textScaler: textChild.textScaler,
      );
      textPainter.layout(maxWidth: constraints.maxWidth);
      final lines = textPainter.computeLineMetrics();
      if (lines.isNotEmpty) {
        lastLineWidth = lines.last.width;
      }
    }

    final spacing = 8.0;
    
    double width;
    double height;
    bool sameLine = false;

    if (lastLineWidth + spacing + timeSize.width <= constraints.maxWidth && textSize.width >= lastLineWidth) {
      width = max(textSize.width, lastLineWidth + spacing + timeSize.width);
      height = textSize.height;
      sameLine = true;
    } else {
      width = max(textSize.width, timeSize.width);
      height = textSize.height + timeSize.height;
    }

    // Determine final size based on constraints
    size = constraints.constrain(Size(width, height));

    final textParentData = textChild.parentData as ChatBubbleLayoutParentData;
    textParentData.offset = Offset.zero;

    final timeParentData = timeChild.parentData as ChatBubbleLayoutParentData;
    if (sameLine) {
      timeParentData.offset = Offset(
        size.width - timeSize.width,
        size.height - timeSize.height,
      );
    } else {
      timeParentData.offset = Offset(
        size.width - timeSize.width,
        textSize.height,
      );
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
