import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

class UtilScroll2d extends StatefulWidget {
  final List<List<dynamic>> list;

  const UtilScroll2d({
    super.key,
    required this.list,
  });

  @override
  UtilScroll2dState createState() => UtilScroll2dState();
}

class UtilScroll2dState extends State<UtilScroll2d> {
  final ScrollController _scrollControllerH = ScrollController();
  final ScrollController _scrollControllerV = ScrollController();

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
              return widget.list[vicinity.yIndex][2];
            },
          ),
        ),
      ),
    );
  }
}

class TwoDimensionalGridView extends TwoDimensionalScrollView {
  final List<List<dynamic>> list;

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
  final List<List<dynamic>> list;

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
  List<List<dynamic>> list;

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
    //final double horizontalPixels = horizontalOffset.pixels;
    //final double verticalPixels = verticalOffset.pixels;
    //final double viewportWidth = viewportDimension.width + cacheExtent;
    //final double viewportHeight = viewportDimension.height + cacheExtent;
    final TwoDimensionalChildBuilderDelegate builderDelegate =
        delegate as TwoDimensionalChildBuilderDelegate;

    // TODO: Optimize to show only visible widgets

    final int maxRowIndex = builderDelegate.maxYIndex!;
    final int maxColumnIndex = builderDelegate.maxXIndex!;

    double maxX = 0;
    double maxY = 0;
    for (int column = 0; column <= maxColumnIndex; column++) {
      for (int row = 0; row <= maxRowIndex; row++) {
        final ChildVicinity vicinity =
            ChildVicinity(xIndex: column, yIndex: row);
        final RenderBox child = buildOrObtainChildFor(vicinity)!;
        child.layout(constraints.loosen());

        // Set widgets at scroll position
        Offset position = Offset(list[row][0].dx - horizontalOffset.pixels, list[row][0].dy - verticalOffset.pixels);
        parentDataOf(child).layoutOffset = position;

        double tmpX = list[row][0].dx + list[row][1].width;
        double tmpY = list[row][0].dy + list[row][1].height;
        if (maxX < tmpX) maxX = tmpX;
        if (maxY < tmpY) maxY = tmpY;
      }
    }

    // Set the min and max scroll extents for each axis.
    final double horizontalExtent = maxX;
    horizontalOffset.applyContentDimensions(
      0,
      clampDouble(
          horizontalExtent - viewportDimension.width, 0.0, double.infinity),
    );
    final double verticalExtent = maxY;
    verticalOffset.applyContentDimensions(
      0,
      clampDouble(
          verticalExtent - viewportDimension.height, 0.0, double.infinity),
    );

    // Super class handles garbage collection too!
  }
  //per class handles garbage collection too!
}
