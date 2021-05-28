import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/src/library.dart';

///
class SidebarItem extends StatefulWidget {
  ///
  const SidebarItem({
    Key? key,
    required this.leading,
    required this.label,
    required this.onClick,
    this.focusColor = CupertinoColors.systemBlue,
    required this.focusNode,
    this.autofocus = false,
    this.semanticsLabel,
  }) : super(key: key);

  ///
  final Widget? leading;

  ///
  final Widget label;

  ///
  final VoidCallback? onClick;

  ///
  final Color focusColor;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// The semantic label used by screen readers.
  final String? semanticsLabel;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('focusColor', focusColor));
    properties.add(DiagnosticsProperty('autoFocus', autofocus));
    properties.add(StringProperty('semanticLabel', semanticsLabel));
  }

  @override
  _SidebarItemState createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool get hasLeading => widget.leading != null;
  bool _focused = false;
  bool _on = false;
  late final Map<Type, Action<Intent>> _actionMap;

  @override
  void initState() {
    super.initState();
    _actionMap = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<Intent>(
        onInvoke: (Intent intent) => _toggleState(),
      ),
    };
  }

  Color get color {
    Color baseColor = Color(0x00000000);
    if (_focused) {
      baseColor = widget.focusColor;
    }
    return baseColor;
  }

  void _toggleState() {
    setState(() => _on = !_on);
  }

  void _handleFocusHighlight(bool value) {
    setState(() => _focused = value);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: GestureDetector(
        onTap: () {
          widget.onClick!();
          widget.focusNode.requestFocus();
        },
        child: FocusableActionDetector(
          actions: _actionMap,
          onShowFocusHighlight: _handleFocusHighlight,
          onFocusChange: (value) {
            _toggleState();
          },
          autofocus: widget.autofocus,
          descendantsAreFocusable: false,
          focusNode: widget.focusNode,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              width: 134,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: _on ? widget.focusColor : Color(0x00000000),
              ),
              //padding: const EdgeInsets.fromLTRB(8.0, 7.0, 7.0, 0.0),
              child: Row(
                children: [
                  const SizedBox(width: 8.0),
                  if (hasLeading) ...[
                    widget.leading!,
                    const SizedBox(width: 8.0),
                  ],
                  widget.label,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
