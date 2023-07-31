part of floating_bottom_bar;

/// [BottomBarItemsChild] class takes [index],[BottomBarItem],[widgetWidth],[onTapCallback] parameters
class BottomBarItemsChild extends StatefulWidget {
  const BottomBarItemsChild({
    required this.index,
    required this.bottomBarItemsModel,
    required this.widgetWidth,
    required this.onTapCallback,
    Key? key,
  }) : super(key: key);
  final BottomBarItem bottomBarItemsModel;
  final Function(int index) onTapCallback;
  final double widgetWidth;
  final int index;

  @override
  BottomBarItemsChildState createState() => BottomBarItemsChildState();
}

class BottomBarItemsChildState extends State<BottomBarItemsChild>
    with TickerProviderStateMixin {
  final ValueNotifier<double> _opacity = ValueNotifier(Dimens.maxOpacity);

  late AnimationController _animationControllerIcon;
  late Animation<Offset> _animationOffsetIcon;

  late AnimationController _animationControllerDot;
  late Animation<Offset> _animationOffsetDot;

  /// [reverseAnimation]
  void reverseAnimation() {
    _animationControllerIcon.reverse();
    _animationControllerDot.reverse();
    changeOpacity();
  }

  /// [forwardAnimation]
  void forwardAnimation() {
    _animationControllerIcon.forward();
    _animationControllerDot.forward();
    changeOpacity();
  }

  void changeOpacity() {
    _opacity.value = (_opacity.value == Dimens.maxOpacity)
        ? Dimens.minOpacity
        : Dimens.maxOpacity;
  }

  @override
  void dispose() {
    _animationControllerIcon.dispose();
    _animationControllerDot.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initializeMembers();
    super.initState();
  }

  void _initializeMembers() {
    _animationControllerIcon = AnimationController(
        vsync: this,
        duration:
            const Duration(milliseconds: Dimens.menuItemAnimationDuration));
    _animationOffsetIcon =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
            .animate(_animationControllerIcon);

    _animationControllerDot = AnimationController(
        vsync: this,
        duration:
            const Duration(milliseconds: Dimens.menuItemAnimationDuration));
    _animationOffsetDot = Tween<Offset>(
            begin: const Offset(0.0, 5.0), end: const Offset(0.0, 1.0))
        .animate(_animationControllerDot);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.widgetWidth,
      alignment: Alignment.center,
      child: InkWell(
        onTap: () => _handleOnTap(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              child: Stack(
                children: [
                  widget.bottomBarItemsModel.icon,
                  SlideTransition(
                    position: _animationOffsetIcon,
                    child: widget.bottomBarItemsModel.iconSelected,
                  ),
                ],
              ),
            ),
            IntrinsicWidth(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SlideTransition(
                      position: _animationOffsetDot,
                      child: SvgPicture.asset(
                        Images.icSvg,
                        package: Strings.bottomNavigatorAnimation,
                        width: Dimens.defaultDotSize,
                        height: Dimens.defaultDotSize,
                        colorFilter: ColorFilter.mode(
                          widget.bottomBarItemsModel.dotColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder<double>(
                    builder: (context, value, child) {
                      return AnimatedOpacity(
                        opacity: value,
                        duration: const Duration(
                          milliseconds: Dimens.menuItemAnimationDuration,
                        ),
                        child: Text(
                          widget.bottomBarItemsModel.title ?? '',
                          style: widget.bottomBarItemsModel.titleStyle,
                        ),
                      );
                    },
                    valueListenable: _opacity,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleOnTap(BuildContext context) {
    widget.onTapCallback(widget.index);
  }
}
