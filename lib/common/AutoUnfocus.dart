// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class AutoUnFocus extends StatefulWidget {
  final Widget child;

  const AutoUnFocus({super.key, required this.child});

  @override
  AutoUnFocusState createState() => AutoUnFocusState();
}

class AutoUnFocusState extends State<AutoUnFocus> {
  bool lastVis = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: (e) {
        final rb = context.findRenderObject() as RenderBox;
        final result = BoxHitTestResult();
        rb.hitTest(result, position: e.position);

        final hitTargetIsEditable =
            result.path.any((entry) => entry.target is RenderEditable);

        if (!hitTargetIsEditable) {
          final currentFocus = FocusScope.of(context);
          currentFocus.unfocus();
        }
      },
      child: KeyboardVisibilityBuilder(builder: (context, visible) {
        if (!visible && lastVis) {
          final currentFocus = FocusScope.of(context);
          currentFocus.unfocus();
        }
        lastVis = visible;
        return widget.child;
      }),
    );
  }
}
