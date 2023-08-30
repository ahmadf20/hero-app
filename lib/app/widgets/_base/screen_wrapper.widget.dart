import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/themes/app.theme.dart';
import '../../core/themes/values.theme.dart';
import 'loading_indicator.widget.dart';

///
/// A wrapper of most common used widget in every screen to make
/// widget tree cleaner and avoid from having boiler plate.
///
/// This wrapper also provides unfocus handler for ios

// TODO: try to put scroll behaviour
// TODO: try to implement to all screen
class ScreenWrapper extends StatelessWidget {
  const ScreenWrapper({
    required this.child,
    Key? key,
    this.onTap,
    this.onWillPop,
    this.onBack,
    this.hasAppBar = true,
    this.floatingActionButton,
    this.appBar,
    this.floatingActionButtonLocation,
    this.backgroundColor = Colors.white,
    this.boxDecoration,
    this.topSafeArea = true,
    this.bottomSafeArea = true,
    this.persistentFooterButtons,
    this.systemUiOverlayStyle,
    this.padding,
    this.hasScreenPadding = true,
    this.hasPaddingBottom = false,
    this.hasBlurBackground = false,
    this.onRefresh,

    // TODO: refactor isLoading from all pages
    this.isLoading = false,
  }) : super(key: key);

  final VoidCallback? onTap;
  final Future<bool> Function()? onWillPop;
  final VoidCallback? onBack;
  final Widget child;
  final bool hasAppBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final PreferredSizeWidget? appBar;
  final Color backgroundColor;
  final bool topSafeArea;
  final bool bottomSafeArea;
  final List<Widget>? persistentFooterButtons;
  final SystemUiOverlayStyle? systemUiOverlayStyle;

  final bool isLoading;
  final bool hasPaddingBottom;
  final bool hasScreenPadding;
  final bool hasBlurBackground;
  final EdgeInsets? padding;
  final Future<void> Function()? onRefresh;

  /// set background color between [Scaffold] and [SafeArea]
  final BoxDecoration? boxDecoration;

  @override
  Widget build(BuildContext context) {
    final finalPadding = (hasScreenPadding
            ? const EdgeInsets.symmetric(
                horizontal: MyPaddings.screen,
              )
            : EdgeInsets.zero)
        .copyWith(
      bottom: hasPaddingBottom ? MyPaddings.screen : padding?.bottom,
      top: padding?.top,
      left: hasScreenPadding ? MyPaddings.screen : padding?.left,
      right: hasScreenPadding ? MyPaddings.screen : padding?.right,
    );

    final showPersistentFooter =
        (persistentFooterButtons?.isNotEmpty ?? false) && !isLoading;

    return GestureDetector(
      onTap: onTap ?? () => Get.focusScope?.unfocus(),
      child: WillPopScope(
        onWillPop: onWillPop,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: systemUiOverlayStyle ?? AppTheme.mySystemUIOverlayStyleDark,
          child: Scaffold(
            persistentFooterButtons:
                showPersistentFooter ? persistentFooterButtons : null,
            backgroundColor: backgroundColor,
            // appBar: !hasAppBar ? null : appBar ?? MyAppBar(onBack: onBack),
            floatingActionButton: isLoading
                ? null
                : (floatingActionButton ?? const SizedBox.shrink()),
            floatingActionButtonLocation: floatingActionButtonLocation ??
                FloatingActionButtonLocation.endFloat,
            body: DecoratedBox(
              decoration:
                  boxDecoration ?? BoxDecoration(color: backgroundColor),
              child: SafeArea(
                maintainBottomViewPadding: true,
                top: topSafeArea,
                bottom: bottomSafeArea,
                child: Padding(
                  padding: finalPadding,
                  child: isLoading
                      ? MyLoadingIndicator.circular()
                      : onRefresh == null
                          ? child
                          : RefreshIndicator(
                              onRefresh: () async => await onRefresh?.call(),
                              child: child,
                            ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
