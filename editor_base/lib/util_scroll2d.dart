import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

class UtilScroll2d extends StatefulWidget {
  final Map<Offset, Widget> widgetsList;
  final Size
      cellSize; // Widgets overlapping cell size will dissapear when scroll is out of view

  const UtilScroll2d({
    super.key,
    required this.widgetsList,
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
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _calculateWidgetSizes());
  }

  @override
  void didUpdateWidget(UtilScroll2d oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.widgetsList != widget.widgetsList) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _calculateWidgetSizes());
    }
  }

  void _calculateWidgetSizes() {
    _widgetSizes.clear();
    widget.widgetsList.forEach((offset, widget) {
      final key = widget.key as GlobalKey?;
      final renderBox = key?.currentContext?.findRenderObject() as RenderBox?;
      final size = renderBox?.size ?? Size.zero;
      _widgetSizes[offset] = size;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Calculem els valors màxims per a x i y a partir de les posicions dels widgets
    int maxX = widget.widgetsList.keys
        .map((offset) => (offset.dx / widget.cellSize.width).ceil())
        .reduce(math.max);
    int maxY = widget.widgetsList.keys
        .map((offset) => (offset.dy / widget.cellSize.height).ceil())
        .reduce(math.max);

    return CupertinoScrollbar(
      controller: _scrollControllerV,
      child: CupertinoScrollbar(
        controller: _scrollControllerH,
        child: TwoDimensionalGridView(
          cellSize: widget.cellSize,
          verticalDetails: ScrollableDetails.vertical(
            controller: _scrollControllerV,
          ),
          horizontalDetails: ScrollableDetails.horizontal(
            controller: _scrollControllerH,
          ),
          diagonalDragBehavior: DiagonalDragBehavior.free,
          delegate: TwoDimensionalChildBuilderDelegate(
            maxXIndex: maxX - 1, // Ajustem segons els valors calculats
            maxYIndex: maxY - 1,
            builder: (BuildContext context, ChildVicinity vicinity) {
              return Stack(clipBehavior: Clip.none, children: [
                ...widget.widgetsList.entries.map((entry) {
                  return Positioned(
                    left: entry.key.dx,
                    top: entry.key.dy,
                    child: entry.value,
                  );
                }),
                Container(
                  width: widget.cellSize.width,
                  height: widget.cellSize.height,
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey),
                  ),
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }
}

class TwoDimensionalGridView extends TwoDimensionalScrollView {
  final Size cellSize;
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
    required this.cellSize,
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
      cellSize: cellSize,
    );
  }
}

class TwoDimensionalGridViewport extends TwoDimensionalViewport {
  final Size cellSize;
  const TwoDimensionalGridViewport({
    super.key,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required TwoDimensionalChildBuilderDelegate super.delegate,
    required super.mainAxis,
    required this.cellSize,
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
      cellSize: cellSize,
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
  final Size cellSize;

  RenderTwoDimensionalGridViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required TwoDimensionalChildBuilderDelegate delegate,
    required super.mainAxis,
    required super.childManager,
    required this.cellSize,
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
