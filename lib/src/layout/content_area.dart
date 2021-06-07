import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/layout/scaffold.dart';
import 'package:macos_ui/src/library.dart';

/// The widget that fills the rest of the body of the macOS [MacosScaffold].
///
/// A [MacosScaffold] can contain only one [ContentArea].
class ContentArea extends StatelessWidget {
  /// Creates a widget that fills the body of the scaffold.
  /// The [builder] can be null to show an empty widget.
  ///
  /// The width of this
  /// widget is automatically calculated in [ScaffoldScope].
  const ContentArea({
    Key? key,
    required this.builder,
  }) : super(key: key);

  /// The builder that creates a child to display in this widget, which will
  /// use the provided [_scrollController] to enable the scrollbar to work.
  ///
  /// Pass the [_scrollController] obtained from this method, to a scrollable
  /// widget used in this method to work with the internal [MacosScrollbar].
  final ScrollableWidgetBuilder? builder;

  static final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScaffoldScope.of(context).contentAreaWidth,
      child: SafeArea(
        left: false,
        right: false,
        child: MacosScrollbar(
          controller: _scrollController,
          child: builder!(context, _scrollController),
        ),
      ),
    );
  }
}
