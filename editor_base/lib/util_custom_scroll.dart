import 'package:flutter/cupertino.dart';

abstract class BaseCustomScroll extends StatefulWidget {
  final double size;
  final double contentSize;
  final Function(double) onChanged;

  const BaseCustomScroll({
    super.key,
    required this.size,
    required this.contentSize,
    required this.onChanged,
  });

  @override
  BaseCustomScrollState createState();
}

abstract class BaseCustomScrollState<T extends BaseCustomScroll>
    extends State<T> {
  double offset = 0;

  double getDraggerSize() {
    if (widget.contentSize <= widget.size) {
      return 0;
    }
    double relation = widget.size / widget.contentSize;
    return widget.size * relation;
  }

  double getDeltaPixels(delta) {
    double draggerSize = getDraggerSize();
    double relation = 2 / (widget.size - draggerSize);
    double normalizedDelta = delta * relation;
    double newOffset = 0;

    newOffset = offset + normalizedDelta;
    newOffset = newOffset.clamp(-1.0, 1.0);

    return newOffset;
  }

  void onDragUpdate(DragUpdateDetails details);

  void setTrackpadDelta(double value) {
    double oldOffset = offset;
    double newOffset = getDeltaPixels(-value);

    // TODO: compute inhertia

    if (oldOffset != newOffset) {
      setState(() {
        offset = newOffset;
        widget.onChanged(offset);
      });
    }
  }

  void setWheelDelta(double value) {
    double oldOffset = offset;
    double newOffset = getDeltaPixels(value);
    if (oldOffset != newOffset) {
      setState(() {
        offset = newOffset;
        widget.onChanged(offset);
      });
    }
  }

  void setOffset(double value) {
    assert(value >= -1.0 && value <= 1.0, 'El valor ha de ser entre -1 i 1.');
    setState(() {
      offset = value;
    });
  }

  double getOffset() {
    return offset;
  }
}
