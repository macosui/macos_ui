import 'package:flutter/services.dart';

import '../../macos_ui.dart';
import '../library.dart';

const double _kResultHeight = 20.0;

/// A macOS-style search field.
class MacosSearchField<T> extends StatefulWidget {
  /// Creates a macOS-style search field.
  ///
  /// To provide a prefilled text entry, pass in a [TextEditingController] with
  /// an initial value to the [controller] parameter.
  ///
  /// To provide a hint placeholder text that appears when the text entry is
  /// empty, pass a [String] to the [placeholder] parameter.
  ///
  /// Based on a [MacosAutoCompleteField] widget.
  ///
  /// When focused or tapped, it opens an overlay showing a [results] list
  /// of [SearchResultItem]s to choose from.
  ///
  /// If searching yields no results, the [emptyWidget] is shown instead (set
  /// by default to [SizedBox.shrink]).
  ///
  /// Set what happens when selecting a suggestion item via the
  /// [onResultSelected] property.
  ///
  /// You can also set a callback action individually for each
  /// [SearchResultItem] via the [onSelected] property.
  const MacosSearchField({
    super.key,
    this.results,
    this.onResultSelected,
    this.maxResultsToShow = 5,
    this.resultHeight = _kResultHeight,
    this.emptyWidget = const SizedBox.shrink(),
    this.controller,
    this.focusNode,
    this.decoration = kDefaultRoundedBorderDecoration,
    this.focusedDecoration = kDefaultFocusedBorderDecoration,
    this.padding = const EdgeInsets.all(4.0),
    this.placeholder = "Search",
    this.placeholderStyle = const TextStyle(
      fontWeight: FontWeight.w400,
      color: CupertinoColors.placeholderText,
    ),
    this.style,
    this.textAlign = TextAlign.start,
    this.autocorrect = true,
    this.autofocus = false,
    this.maxLines,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.onChanged,
    this.inputFormatters,
    this.enabled = true,
    this.onTap,
  });

  /// List of results for the searchfield.
  ///
  /// Each suggestion should have a unique searchKey.
  ///
  /// ```dart
  /// ['ABC', 'DEF', 'GHI', 'JKL']
  ///   .map((e) => SearchResultItem(e, child: Text(e)))
  ///   .toList(),
  /// ```
  final List<SearchResultItem>? results;

  /// The action to perform when any suggestion is selected.
  final Function(SearchResultItem)? onResultSelected;

  /// Specifies the number of results that will be displayed.
  ///
  /// Defaults to `5`.
  final int maxResultsToShow;

  /// Specifies the height of each suggestion item in the list.
  ///
  /// When not specified, the default value is `20.0`.
  final double resultHeight;

  /// Widget to show when the search returns no results.
  ///
  /// Defaults to [SizedBox.shrink].
  final Widget emptyWidget;

  /// Specifies the `TextEditingController` for [MacosSearchField].
  final TextEditingController? controller;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// Controls the [BoxDecoration] of the box behind the text input.
  ///
  /// Defaults to having a rounded rectangle grey border and can be null to have
  /// no box decoration.
  final BoxDecoration? decoration;

  /// Controls the [BoxDecoration] of the box behind the text input when focused.
  /// This decoration is drawn above [decoration].
  ///
  /// Defaults to having a rounded rectangle blue border and can be null to have
  /// no box decoration.
  final BoxDecoration? focusedDecoration;

  /// Padding around the text entry area.
  ///
  /// Defaults to a padding of 6 pixels on all sides and can be null.
  final EdgeInsets padding;

  /// A lighter colored placeholder hint that appears on the first line of the
  /// text field when the text entry is empty.
  ///
  /// Defaults to having no placeholder text.
  ///
  /// The text style of the placeholder text matches that of the text field's
  /// main text entry except a lighter font weight and a grey font color.
  final String? placeholder;

  /// The style to use for the placeholder text.
  ///
  /// The [placeholderStyle] is merged with the [style] [TextStyle] when applied
  /// to the [placeholder] text. To avoid merging with [style], specify
  /// [TextStyle.inherit] as false.
  ///
  /// Defaults to the [style] property with w300 font weight and grey color.
  ///
  /// If specifically set to null, placeholder's style will be the same as [style].
  final TextStyle? placeholderStyle;

  /// The style to use for the text being edited.
  ///
  /// Also serves as a base for the [placeholder] text's style.
  ///
  /// Defaults to the standard font style from [MacosTheme] if null.
  final TextStyle? style;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign textAlign;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.editableText.autocorrect}
  final bool autocorrect;

  /// {@macro flutter.widgets.editableText.maxLines}
  final int? maxLines;

  /// {@macro flutter.widgets.editableText.minLines}
  final int? minLines;

  /// {@macro flutter.widgets.editableText.expands}
  final bool expands;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  ///
  /// After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforcement] is set to
  /// [MaxLengthEnforcement.none].
  ///
  /// The TextField enforces the length with a
  /// [LengthLimitingTextInputFormatter], which is evaluated after the supplied
  /// [inputFormatters], if any.
  ///
  /// This value must be either null or greater than zero. If set to null
  /// (the default), there is no limit to the number of characters allowed.
  ///
  /// Whitespace characters (e.g. newline, space, tab) are included in the
  /// character count.
  ///
  /// {@macro flutter.services.lengthLimitingTextInputFormatter.maxLength}
  final int? maxLength;

  /// Determines how the [maxLength] limit should be enforced.
  ///
  /// If [MaxLengthEnforcement.none] is set, additional input beyond [maxLength]
  /// will not be enforced by the limit.
  ///
  /// {@macro flutter.services.textFormatter.effectiveMaxLengthEnforcement}
  ///
  /// {@macro flutter.services.textFormatter.maxLengthEnforcement}
  final MaxLengthEnforcement? maxLengthEnforcement;

  /// Use this to get the current search query of the [MacosSearchField].
  ///
  /// {@macro flutter.widgets.editableText.onChanged}
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// Disables the text field when false.
  ///
  /// Text fields in disabled states have a light grey background and don't
  /// respond to touch events including the [prefix], [suffix] and the clear
  /// button.
  final bool? enabled;

  /// {@macro flutter.material.textfield.onTap}
  final GestureTapCallback? onTap;

  @override
  State<MacosSearchField<T>> createState() => _MacosSearchFieldState();
}

class _MacosSearchFieldState<T> extends State<MacosSearchField<T>> {
  @override
  Widget build(BuildContext context) {
    return MacosAutoCompleteField(
      key: widget.key,
      results: widget.results,
      onResultSelected: widget.onResultSelected,
      maxResultsToShow: widget.maxResultsToShow,
      resultHeight: widget.resultHeight,
      emptyWidget: widget.emptyWidget,
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: widget.decoration,
      focusedDecoration: widget.focusedDecoration,
      padding: widget.padding,
      placeholder: widget.placeholder,
      placeholderStyle: widget.placeholderStyle,
      prefix: const Padding(
        padding: EdgeInsets.symmetric(),
        child: MacosIcon(CupertinoIcons.search),
      ),
      clearButtonMode: OverlayVisibilityMode.editing,
      style: widget.style,
      textAlign: widget.textAlign,
      autocorrect: widget.autocorrect,
      autofocus: widget.autofocus,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters,
      enabled: widget.enabled,
      onTap: widget.onTap,
    );
  }
}
