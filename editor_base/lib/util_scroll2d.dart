import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

class UtilScroll2d extends StatefulWidget {
  final Map<ChildVicinity, List<dynamic>> list;
  final Size
      cellSize; // Widgets overlapping cell size will dissapear when scroll is out of view

  const UtilScroll2d({
    super.key,
    required this.list,
    this.cellSize = const Size(1500, 1500),
  });

  @override
  UtilScroll2dState createState() => UtilScroll2dState();
}

class UtilScroll2dState extends State<UtilScroll2d> {
  final ScrollController _scrollControllerH = ScrollController();
  final ScrollController _scrollControllerV = ScrollController();
  final Map<Offset, Size> _widgetSizes = {};

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      controller: _scrollControllerV,
      child: CupertinoScrollbar(
        controller: _scrollControllerH,
        child: TwoDimensionalGridView(
          list: widget.list,
          verticalDetails: ScrollableDetails.vertical(
            controller: _scrollControllerV,
          ),
          horizontalDetails: ScrollableDetails.horizontal(
            controller: _scrollControllerH,
          ),
          diagonalDragBehavior: DiagonalDragBehavior.free,
          delegate: TwoDimensionalChildBuilderDelegate(
            maxXIndex: 0,
            maxYIndex: widget.list.length - 1,
            builder: (BuildContext context, ChildVicinity vicinity) {
              return widget.list[vicinity]![1];
            },
          ),
        ),
      ),
    );
  }
}

class TwoDimensionalGridView extends TwoDimensionalScrollView {
  final Map<ChildVicinity, List<dynamic>> list;

  const TwoDimensionalGridView({
    super.key,
    super.primary,
    super.mainAxis = Axis.vertical,
    super.verticalDetails,
    super.horizontalDetails,
    required TwoDimensionalChildBuilderDelegate delegate,
    super.cacheExtent,
    super.diagonalDragBehavior = DiagonalDragBehavior.none,
    super.dragStartBehavior = DragStartBehavior.start,
    super.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    super.clipBehavior = Clip.hardEdge,
    required this.list,
  }) : super(delegate: delegate);

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset verticalOffset,
    ViewportOffset horizontalOffset,
  ) {
    return TwoDimensionalGridViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalDetails.direction,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalDetails.direction,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
      list: list,
    );
  }
}

class TwoDimensionalGridViewport extends TwoDimensionalViewport {
  final Map<ChildVicinity, List<dynamic>> list;

  const TwoDimensionalGridViewport({
    super.key,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required TwoDimensionalChildBuilderDelegate super.delegate,
    required super.mainAxis,
    required this.list,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  });

  @override
  RenderTwoDimensionalViewport createRenderObject(BuildContext context) {
    return RenderTwoDimensionalGridViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalAxisDirection,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalAxisDirection,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      childManager: context as TwoDimensionalChildManager,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
      list: list,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderTwoDimensionalGridViewport renderObject,
  ) {
    renderObject
      ..horizontalOffset = horizontalOffset
      ..horizontalAxisDirection = horizontalAxisDirection
      ..verticalOffset = verticalOffset
      ..verticalAxisDirection = verticalAxisDirection
      ..mainAxis = mainAxis
      ..delegate = delegate
      ..cacheExtent = cacheExtent
      ..clipBehavior = clipBehavior;
  }
}

class RenderTwoDimensionalGridViewport extends RenderTwoDimensionalViewport {
  Map<ChildVicinity, List<dynamic>> list;

  RenderTwoDimensionalGridViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required TwoDimensionalChildBuilderDelegate delegate,
    required super.mainAxis,
    required super.childManager,
    required this.list,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  @override
  void layoutChildSequence() {
    final double horizontalPixels = horizontalOffset.pixels;
    final double verticalPixels = verticalOffset.pixels;
    final double viewportWidth = viewportDimension.width + cacheExtent;
    final double viewportHeight = viewportDimension.height + cacheExtent;
    final TwoDimensionalChildBuilderDelegate builderDelegate =
        delegate as TwoDimensionalChildBuilderDelegate;

    for (int cnt = 0; cnt < list.length; cnt++) {
      final ChildVicinity vicinity = list.keys.elementAt(cnt);
      final RenderBox child = buildOrObtainChildFor(vicinity)!;
      //child.layout(constraints.loosen());
    }

    Size cellSize = Size(200, 200);
    final int maxRowIndex = builderDelegate.maxYIndex!;
    final int maxColumnIndex = builderDelegate.maxXIndex!;

    final int leadingColumn =
        math.max((horizontalPixels / cellSize.width).floor(), 0);
    final int leadingRow =
        math.max((verticalPixels / cellSize.height).floor(), 0);

    final int trailingColumn = math.min(
      ((horizontalPixels + viewportWidth) / cellSize.width).ceil(),
      maxColumnIndex,
    );
    final int trailingRow = math.min(
      ((verticalPixels + viewportHeight) / cellSize.height).ceil(),
      maxRowIndex,
    );

    double xLayoutOffset =
        (leadingColumn * cellSize.width) - horizontalOffset.pixels;
    double yLayoutOffset = 0;
    for (int column = leadingColumn; column <= trailingColumn; column++) {
      yLayoutOffset = (leadingRow * cellSize.height) - verticalOffset.pixels;
      for (int row = leadingRow; row <= trailingRow; row++) {
        final ChildVicinity vicinity =
            ChildVicinity(xIndex: column, yIndex: row);
        final RenderBox child = buildOrObtainChildFor(vicinity)!;
        child.layout(constraints.loosen());

        // Subclasses only need to set the normalized layout offset. The super
        // class adjusts for reversed axes.
        parentDataOf(child).layoutOffset = Offset(xLayoutOffset, yLayoutOffset);
        yLayoutOffset += cellSize.height;
      }
      xLayoutOffset += cellSize.width;
    }

    // Set the min and max scroll extents for each axis.
    final double horizontalExtent = cellSize.width * (maxColumnIndex + 1);
    horizontalOffset.applyContentDimensions(
      0,
      clampDouble(
          horizontalExtent - viewportDimension.width, 0.0, double.infinity),
    );
    final double verticalExtent = cellSize.height * (maxRowIndex + 1);
    verticalOffset.applyContentDimensions(
      0,
      clampDouble(
          verticalExtent - viewportDimension.height, 0.0, double.infinity),
    );

    // Super class handles garbage collection too!
  }
  //per class handles garbage collection too!
}
