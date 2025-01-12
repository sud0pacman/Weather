import 'package:flutter/material.dart';
import 'package:weather_now/presentation/screens/locations/widget/fade_animation.dart';
import 'package:weather_now/presentation/screens/locations/widget/one_ui_scroll_physics.dart';
import 'package:weather_now/utils/helpers/app_helpers.dart';
import 'package:weather_now/utils/theme/app_styles.dart';

class OneUiNestedScrollView extends StatefulWidget {
  final double? expendedHeight;
  final double? toolbarHeight;
  final Widget? expandedWidget;
  final Widget? collapsedWidget;
  final BoxDecoration? boxDecoration;
  final Widget? leadingIcon;
  final List<Widget>? actions;
  final Widget body;
  final Color? sliverBackgroundColor;

  final GlobalKey<NestedScrollViewState>? globalKey;

  const OneUiNestedScrollView(
      {super.key,
        this.expendedHeight,
        this.toolbarHeight,
        this.expandedWidget,
        this.collapsedWidget,
        this.boxDecoration,
        this.leadingIcon,
        this.actions,
        required this.body,
        this.sliverBackgroundColor,
        this.globalKey});

  @override
  State<OneUiNestedScrollView> createState() => _OneUiNestedScrollViewState();
}

class _OneUiNestedScrollViewState extends State<OneUiNestedScrollView> {
  late double _expandedHeight;
  late double _toolbarHeight;
  late GlobalKey<NestedScrollViewState>? _nestedScrollViewState;

  Future<void>? scrollAnimate;

  bool _isDragging = false;  // Add this flag

  double calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio = (constraints.maxHeight - _toolbarHeight) / (_expandedHeight - _toolbarHeight);

    if (expandRatio > 1.0) expandRatio = 1;
    if (expandRatio < 0.0) expandRatio = 0;

    return expandRatio;
  }

  List<Widget> headerSliverBuilder(context, innerBoxIsScrolled) {
    return [
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
          pinned: true,
          expandedHeight: _expandedHeight,
          toolbarHeight: _toolbarHeight,
          flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final expandRatio = calculateExpandRatio(constraints);
                final animation = AlwaysStoppedAnimation(expandRatio);

                return Stack(
                  children: [
                    Container(decoration: widget.boxDecoration,),

                    if (widget.expandedWidget != null)
                      Center(
                        child: FadeAnimation(
                          animation: animation,
                          isExpandedWidget: true,
                          child: widget.expandedWidget!,
                        ),
                      ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: _toolbarHeight,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (widget.leadingIcon != null) widget.leadingIcon!,

                            if (widget.collapsedWidget != null)
                              Padding(
                                padding: EdgeInsets.only(left: widget.leadingIcon != null ? 8 : 32),
                                child: FadeAnimation(
                                  animation: animation,
                                  isExpandedWidget: false,
                                  child: widget.collapsedWidget!,
                                ),
                              ),

                            if (widget.actions != null)
                              Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: widget.actions!.reversed.toList(),
                                  )
                              )
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }
          ),
        ),
      )
    ];
  }

  Widget body() {
    return Container(
      color: widget.sliverBackgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Builder(builder: (BuildContext context) {
        return CustomScrollView(
          slivers: [
            SliverOverlapInjector(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)
            ),
            widget.body
          ],
        );
      }),
    );
  }

  bool onNotification(ScrollEndNotification notification) {
    final scrollViewState = _nestedScrollViewState!.currentState;
    final outerController = scrollViewState!.outerController;

    if (scrollViewState.innerController.position.pixels == 0 && !outerController.position.atEdge) {
      final range = _expandedHeight - _toolbarHeight;
      final snapOffset = (outerController.offset / range) > 0.55 ? range : 0.0;

      Future.microtask(() async {
        if (scrollAnimate != null) await scrollAnimate;
        scrollAnimate = outerController.animateTo(snapOffset, duration: const Duration(milliseconds: 150), curve: Curves.ease);
      });
    }

    return false;
  }

  @override
  void initState() {
    _nestedScrollViewState = widget.globalKey ?? GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _expandedHeight = widget.expendedHeight ?? AppHelpers.screenHeight(context) * 3 / 8;
    _toolbarHeight = widget.toolbarHeight ?? kToolbarHeight;

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overScroll) {
        overScroll.disallowIndicator();
        return true;
      },
      child: NotificationListener<ScrollEndNotification>(
        onNotification: onNotification,
        child: NestedScrollView(
          key: _nestedScrollViewState,
          headerSliverBuilder: headerSliverBuilder,
          physics: _isDragging ? const NeverScrollableScrollPhysics() : OneUiScrollPhysics(_expandedHeight),  // Adjust scroll physics
          body: GestureDetector(
            onPanStart: (_) => setState(() => _isDragging = true),    // Set dragging flag
            onPanEnd: (_) => setState(() => _isDragging = false),     // Reset dragging flag
            child: body(),
          ),
        ),
      ),
    );
  }
}
