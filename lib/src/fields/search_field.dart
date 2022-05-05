import 'dart:async';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';
import 'package:flutter/services.dart';

const BorderRadius _kBorderRadius = BorderRadius.all(Radius.circular(7.0));
const double _kSuggestionHeight = 20.0;
const double _kSuggestionsOverlayMargin = 12.0;

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
  /// Based on a [MacosTextField] widget.
  ///
  /// When focused or tapped, it opens an overlay showing a [suggestions] list
  /// of [SearchSuggestionItem]s to choose from.
  ///
  /// If searching yields no results, the [emptyWidget] is shown instead (set
  /// by default to [SizedBox.shrink]).
  ///
  /// Set what happens when selecting a suggestion item via the
  /// [onSuggestionSelected] property.
  ///
  /// You can also set a callback action individually for each
  /// [SearchSuggestionItem] via the [onSelected] property.
  const MacosSearchField({
    Key? key,
    this.suggestions,
    this.onSuggestionSelected,
    this.maxSuggestionsToShow = 5,
    this.suggestionHeight = _kSuggestionHeight,
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
  }) : super(key: key);

  /// List of suggestions for the searchfield.
  /// each suggestion should have a unique searchKey
  ///
  /// ```dart
  /// ['ABC', 'DEF', 'GHI', 'JKL']
  ///   .map((e) => SearchSuggestionItem(e, child: Text(e)))
  ///   .toList(),
  /// ```
  final List<SearchSuggestionItem>? suggestions;

  /// Callback when any suggestion is selected.
  final Function(SearchSuggestionItem)? onSuggestionSelected;

  /// Specifies the number of suggestions that will be displayed.
  ///
  /// It defaults to 5.
  final int maxSuggestionsToShow;

  /// Specifies height for each suggestion item in the list.
  ///
  /// When not specified, the default value is `20.0`.
  final double suggestionHeight;

  /// Widget to show when the search returns no results.
  ///
  /// Defaults to [SizedBox.shrink]
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
  _MacosSearchFieldState<T> createState() => _MacosSearchFieldState();
}

class _MacosSearchFieldState<T> extends State<MacosSearchField<T>> {
  final StreamController<List<SearchSuggestionItem?>?> suggestionStream =
      StreamController<List<SearchSuggestionItem?>?>.broadcast();
  FocusNode? _focus;
  bool isSuggestionExpanded = false;
  TextEditingController? searchController;
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  double height = 0.0;
  bool showOverlayAbove = false;

  @override
  void initState() {
    super.initState();
    searchController = widget.controller ?? TextEditingController();
    if (widget.focusNode != null) {
      _focus = widget.focusNode;
    } else {
      _focus = FocusNode();
    }
    _focus!.addListener(() {
      if (mounted) {
        setState(() {
          isSuggestionExpanded = _focus!.hasFocus;
        });
      }
      if (isSuggestionExpanded) {
        _overlayEntry = _createOverlay();
        Overlay.of(context)!.insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      suggestionStream.sink.add(null);
      suggestionStream.sink.add(widget.suggestions);
    });
  }

  @override
  void dispose() {
    suggestionStream.close();
    if (widget.controller == null) {
      searchController!.dispose();
    }
    if (widget.focusNode == null) {
      _focus!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: MacosTextField(
            placeholder: widget.placeholder,
            prefix: const Padding(
              padding: EdgeInsets.symmetric(),
              child: MacosIcon(CupertinoIcons.search),
            ),
            clearButtonMode: OverlayVisibilityMode.editing,
            onTap: () {
              suggestionStream.sink.add(widget.suggestions);
              if (mounted) {
                setState(() {
                  isSuggestionExpanded = true;
                });
              }
              widget.onTap?.call();
            },
            controller: widget.controller ?? searchController,
            focusNode: _focus,
            style: widget.style,
            onChanged: (query) {
              final searchResult = <SearchSuggestionItem>[];
              if (query.isEmpty) {
                suggestionStream.sink.add(widget.suggestions);
                return;
              }
              if (widget.suggestions != null) {
                for (final suggestion in widget.suggestions!) {
                  if (suggestion.searchKey
                      .toLowerCase()
                      .contains(query.toLowerCase())) {
                    searchResult.add(suggestion);
                  }
                }
              }
              suggestionStream.sink.add(searchResult);
              widget.onChanged?.call(query);
            },
            decoration: widget.decoration,
            focusedDecoration: widget.focusedDecoration,
            padding: widget.padding,
            placeholderStyle: widget.placeholderStyle,
            textAlign: widget.textAlign,
            autocorrect: widget.autocorrect,
            autofocus: widget.autofocus,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            expands: widget.expands,
            maxLength: widget.maxLength,
            maxLengthEnforcement: widget.maxLengthEnforcement,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
          ),
        ),
      ],
    );
  }

  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
      builder: (context) => StreamBuilder<List<SearchSuggestionItem?>?>(
        stream: suggestionStream.stream,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<SearchSuggestionItem?>?> snapshot,
        ) {
          late var count = widget.maxSuggestionsToShow;
          if (snapshot.data != null) {
            count = snapshot.data!.length;
          }
          return Positioned(
            left: offset.dx,
            width: size.width,
            child: CompositedTransformFollower(
              offset: _getYOffset(offset, size, count),
              link: _layerLink,
              child: _suggestionsBuilder(),
            ),
          );
        },
      ),
    );
  }

  Offset _getYOffset(Offset widgetOffset, Size fieldSize, int resultCount) {
    final size = MediaQuery.of(context).size;
    final position = widgetOffset.dy;
    if ((position + height) < (size.height - widget.suggestionHeight * 2)) {
      return Offset(0, fieldSize.height);
    } else {
      if (resultCount > widget.maxSuggestionsToShow) {
        showOverlayAbove = false;
        return Offset(
          0,
          -(widget.suggestionHeight * widget.maxSuggestionsToShow),
        );
      } else {
        showOverlayAbove = true;
        return Offset(0, -(widget.suggestionHeight * resultCount));
      }
    }
  }

  Widget _suggestionsBuilder() {
    return StreamBuilder<List<SearchSuggestionItem?>?>(
      stream: suggestionStream.stream,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<SearchSuggestionItem?>?> snapshot,
      ) {
        if (widget.suggestions == null ||
            snapshot.data == null ||
            !isSuggestionExpanded) {
          return const SizedBox.shrink();
        } else if (snapshot.data!.isEmpty) {
          return widget.emptyWidget;
        } else {
          if (snapshot.data!.length > widget.maxSuggestionsToShow) {
            height = widget.suggestionHeight * widget.maxSuggestionsToShow;
          } else if (snapshot.data!.length == 1) {
            height = widget.suggestionHeight;
          } else {
            height = snapshot.data!.length * widget.suggestionHeight;
          }
          height += _kSuggestionsOverlayMargin;

          print(MacosSearchFieldTheme.of(context));
          return MacosOverlayFilter(
            borderRadius: _kBorderRadius,
            height: height,
            alignment: Alignment.centerLeft,
            color: MacosSearchFieldTheme.of(context).suggestionsBackgroundColor,
            child: ListView.builder(
              reverse: showOverlayAbove,
              padding: const EdgeInsets.all(6.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var selectedItem = snapshot.data![index]!;
                return _SearchSuggestionItemButton(
                  suggestionHeight: widget.suggestionHeight,
                  onPressed: () {
                    searchController!.text = selectedItem.searchKey;
                    searchController!.selection = TextSelection.fromPosition(
                      TextPosition(
                        offset: searchController!.text.length,
                      ),
                    );
                    selectedItem.onSelected?.call();
                    // Hide the suggestions
                    suggestionStream.sink.add(null);
                    if (widget.onSuggestionSelected != null) {
                      widget.onSuggestionSelected!(selectedItem);
                    }
                  },
                  child: selectedItem.child ??
                      Text(
                        selectedItem.searchKey,
                      ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

/// An item to show in the search results of a search field.
class SearchSuggestionItem {
  /// Creates a macOS-styled item to show in the search results of a search
  /// field.
  ///
  /// Can be further customized via its [child] property.
  const SearchSuggestionItem(
    this.searchKey, {
    this.child,
    this.onSelected,
  });

  /// The string to search for.
  final String searchKey;

  /// The widget to display in the search results overlay. If not specified, a
  /// [Text] widget with the default styling will appear instead.
  final Widget? child;

  /// The callback to call when this item is selected from the search results.
  final VoidCallback? onSelected;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SearchSuggestionItem &&
            runtimeType == other.runtimeType &&
            searchKey == other.searchKey;
  }

  @override
  int get hashCode => searchKey.hashCode;
}

/// A wrapper around the [SearchSuggestionItem] to provide it with the
/// appropriate mouse and hover detection.
class _SearchSuggestionItemButton extends StatefulWidget {
  const _SearchSuggestionItemButton({
    Key? key,
    this.onPressed,
    required this.child,
    required this.suggestionHeight,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget child;
  final double suggestionHeight;

  @override
  State<_SearchSuggestionItemButton> createState() =>
      _SearchSuggestionItemButtonState();
}

class _SearchSuggestionItemButtonState
    extends State<_SearchSuggestionItemButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final brightness = MacosTheme.brightnessOf(context);
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() => _isHovered = true);
      },
      onExit: (_) {
        setState(() => _isHovered = false);
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          height: widget.suggestionHeight,
          decoration: BoxDecoration(
            color: _isHovered
                ? MacosSearchFieldTheme.of(context).highlightColor
                : Colors.transparent,
            borderRadius: _kBorderRadius,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 13.0,
              color: _isHovered
                  ? MacosColors.white
                  : brightness.resolve(
                      MacosColors.black,
                      MacosColors.white,
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
