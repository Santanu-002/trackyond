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

    // 3. Determine if they fit on the same line
    // We need to know the width of the last line of text.
    // Since we don't have direct access to internal text layout easily without
    // casting to RenderParagraph or similar, we'll try a common heuristic.
    
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

    final double width;
    final double height;

    final spacing = 8.0; // Space between text and time

    if (lastLineWidth + spacing + timeSize.width <= constraints.maxWidth && textSize.width >= lastLineWidth) {
      // Fits on the same line if the total width doesn't exceed constraints
      // and we account for the fact that the bubble width might be larger than last line
      width = max(textSize.width, lastLineWidth + spacing + timeSize.width);
      height = textSize.height;
      
      final textParentData = textChild.parentData as ChatBubbleLayoutParentData;
      textParentData.offset = Offset.zero;

      final timeParentData = timeChild.parentData as ChatBubbleLayoutParentData;
      timeParentData.offset = Offset(
        width - timeSize.width,
        height - timeSize.height,
      );
    } else {
      // Doesn't fit, move to new line
      width = max(textSize.width, timeSize.width);
      height = textSize.height + timeSize.height;

      final textParentData = textChild.parentData as ChatBubbleLayoutParentData;
      textParentData.offset = Offset.zero;

      final timeParentData = timeChild.parentData as ChatBubbleLayoutParentData;
      timeParentData.offset = Offset(
        width - timeSize.width,
        textSize.height,
      );
    }

    size = constraints.constrain(Size(width, height));
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
