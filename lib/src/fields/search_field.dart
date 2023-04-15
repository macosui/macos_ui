import 'dart:async';

import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

const BorderRadius _kBorderRadius = BorderRadius.all(Radius.circular(7.0));
const double _kResultHeight = 20.0;
const double _kResultsOverlayMargin = 12.0;

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
  final StreamController<List<SearchResultItem?>?> suggestionStream =
      StreamController<List<SearchResultItem?>?>.broadcast();
  FocusNode? _focus;
  bool isResultExpanded = false;
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
          isResultExpanded = _focus!.hasFocus;
        });
      }
      if (isResultExpanded) {
        _overlayEntry = _createOverlay();
        Overlay.of(context).insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      suggestionStream.sink.add(null);
      suggestionStream.sink.add(widget.results);
    });
  }

  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
      builder: (context) => StreamBuilder<List<SearchResultItem?>?>(
        stream: suggestionStream.stream,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<SearchResultItem?>?> snapshot,
        ) {
          late var count = widget.maxResultsToShow;
          if (snapshot.data != null) {
            count = snapshot.data!.length;
          }
          return Positioned(
            left: offset.dx,
            width: size.width,
            child: CompositedTransformFollower(
              offset: _getYOffset(offset, size, count),
              link: _layerLink,
              child: _resultsBuilder(),
            ),
          );
        },
      ),
    );
  }

  Offset _getYOffset(Offset widgetOffset, Size fieldSize, int resultCount) {
    final size = MediaQuery.of(context).size;
    final position = widgetOffset.dy;
    if ((position + height) < (size.height - widget.resultHeight * 2)) {
      return Offset(0, fieldSize.height);
    } else {
      if (resultCount > widget.maxResultsToShow) {
        showOverlayAbove = false;
        return Offset(
          0,
          -(widget.resultHeight * widget.maxResultsToShow),
        );
      } else {
        showOverlayAbove = true;
        return Offset(0, -(widget.resultHeight * resultCount));
      }
    }
  }

  Widget _resultsBuilder() {
    return StreamBuilder<List<SearchResultItem?>?>(
      stream: suggestionStream.stream,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<SearchResultItem?>?> snapshot,
      ) {
        if (widget.results == null ||
            snapshot.data == null ||
            !isResultExpanded) {
          return const SizedBox.shrink();
        } else if (snapshot.data!.isEmpty) {
          return MacosOverlayFilter(
            borderRadius: _kBorderRadius,
            child: widget.emptyWidget,
          );
        } else {
          if (snapshot.data!.length > widget.maxResultsToShow) {
            height = widget.resultHeight * widget.maxResultsToShow;
          } else if (snapshot.data!.length == 1) {
            height = widget.resultHeight;
          } else {
            height = snapshot.data!.length * widget.resultHeight;
          }
          height += _kResultsOverlayMargin;

          return TextFieldTapRegion(
            child: MacosOverlayFilter(
              borderRadius: _kBorderRadius,
              color: MacosSearchFieldTheme.of(context).resultsBackgroundColor,
              child: SizedBox(
                height: height,
                child: ListView.builder(
                  reverse: showOverlayAbove,
                  padding: const EdgeInsets.all(6.0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var selectedItem = snapshot.data![index]!;
                    return _SearchResultItemButton(
                      resultHeight: widget.resultHeight,
                      onPressed: () {
                        searchController!.text = selectedItem.searchKey;
                        searchController!.selection =
                            TextSelection.fromPosition(
                          TextPosition(
                            offset: searchController!.text.length,
                          ),
                        );
                        selectedItem.onSelected?.call();
                        // Hide the results
                        suggestionStream.sink.add(null);
                        if (widget.onResultSelected != null) {
                          widget.onResultSelected!(selectedItem);
                        }
                      },
                      child: selectedItem.child ?? Text(selectedItem.searchKey),
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
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
              suggestionStream.sink.add(widget.results);
              if (mounted) {
                setState(() {
                  isResultExpanded = true;
                });
              }
              widget.onTap?.call();
            },
            controller: widget.controller ?? searchController,
            focusNode: _focus,
            style: widget.style,
            onChanged: (query) {
              final searchResult = <SearchResultItem>[];
              if (query.isEmpty) {
                suggestionStream.sink.add(widget.results);
                return;
              }
              if (widget.results != null) {
                for (final suggestion in widget.results!) {
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
}

/// An item to show in the search results of a search field.
class SearchResultItem {
  /// Creates a macOS-styled item to show in the search results of a search
  /// field.
  ///
  /// Can be further customized via its [child] property.
  const SearchResultItem(
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
        other is SearchResultItem &&
            runtimeType == other.runtimeType &&
            searchKey == other.searchKey;
  }

  @override
  int get hashCode => searchKey.hashCode;
}

/// A wrapper around the [SearchResultItem] to provide it with the
/// appropriate mouse and hover detection.
class _SearchResultItemButton extends StatefulWidget {
  // ignore: use_super_parameters
  const _SearchResultItemButton({
    Key? key,
    this.onPressed,
    required this.child,
    required this.resultHeight,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget child;
  final double resultHeight;

  @override
  State<_SearchResultItemButton> createState() =>
      _SearchResultItemButtonState();
}

class _SearchResultItemButtonState extends State<_SearchResultItemButton> {
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
          height: widget.resultHeight,
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
