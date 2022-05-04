import 'dart:async';
import 'dart:ui';
import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

const BorderRadius _kBorderRadius = BorderRadius.all(Radius.circular(7.0));
const double _kMenuItemHeight = 20.0;
const EdgeInsets _kMenuItemPadding = EdgeInsets.symmetric(horizontal: 6.0);

enum Suggestion {
  /// shows suggestions when searchfield is brought into focus
  expand,

  /// keeps the suggestion overlay hidden until
  /// first letter is entered
  hidden,
}

// enum to define the Focus of the searchfield when a suggestion is tapped
enum SuggestionAction {
  /// shift to next focus
  next,

  /// close keyboard and unfocus
  unfocus,
}

// /// A macOS-style search field.
// class MacosSearchField extends StatefulWidget {
//   /// Creates a macOS-style search field.
//   ///
//   /// To provide a prefilled text entry, pass in a [TextEditingController] with
//   /// an initial value to the [controller] parameter.
//   ///
//   /// To provide a hint placeholder text that appears when the text entry is
//   /// empty, pass a [String] to the [placeholder] parameter.
//   ///
//   /// The [maxLines] property can be set to null to remove the restriction on
//   /// the number of lines. In this mode, the intrinsic height of the widget will
//   /// grow as the number of lines of text grows. By default, it is `1`, meaning
//   /// this is a single-line text field and will scroll horizontally when
//   /// overflown. [maxLines] must not be zero.
//   ///
//   /// The text cursor is not shown if [showCursor] is false or if [showCursor]
//   /// is null (the default) and [readOnly] is true.
//   ///
//   /// If specified, the [maxLength] property must be greater than zero.
//   ///
//   ///
//   /// The [autocorrect], [autofocus], [expands], [maxLengthEnforcement],[readOnly],
//   /// [textAlign], and [enableSuggestions] properties must not be null.
//   ///
//   /// See also:
//   ///
//   ///  * [minLines], which is the minimum number of lines to occupy when the
//   ///    content spans fewer lines.
//   ///  * [expands], to allow the widget to size itself to its parent's height.
//   ///  * [maxLength], which discusses the precise meaning of "number of
//   ///    characters" and how it may differ from the intuitive meaning.
//   const MacosSearchField({
//     Key? key,
//     this.controller,
//     this.focusNode,
//     this.decoration = kDefaultRoundedBorderDecoration,
//     this.focusedDecoration = kDefaultFocusedBorderDecoration,
//     this.padding = const EdgeInsets.all(4.0),
//     this.placeholder,
//     this.placeholderStyle = const TextStyle(
//       fontWeight: FontWeight.w400,
//       color: CupertinoColors.placeholderText,
//     ),
//     this.style,
//     this.textAlign = TextAlign.start,
//     this.autocorrect = true,
//     this.autofocus = false,
//     this.enableSuggestions = true,
//     this.maxLines = 1,
//     this.minLines,
//     this.expands = false,
//     this.maxLength,
//     this.maxLengthEnforcement,
//     this.onChanged,
//     this.onEditingComplete,
//     this.onSubmitted,
//     this.inputFormatters,
//     this.enabled = true,
//     this.onTap,
//   }) : super(key: key);

//   /// Controls the text being edited.
//   ///
//   /// If null, this widget will create its own [TextEditingController].
//   final TextEditingController? controller;

//   /// {@macro flutter.widgets.Focus.focusNode}
//   final FocusNode? focusNode;

//   /// Controls the [BoxDecoration] of the box behind the text input.
//   ///
//   /// Defaults to having a rounded rectangle grey border and can be null to have
//   /// no box decoration.
//   final BoxDecoration? decoration;

//   /// Controls the [BoxDecoration] of the box behind the text input when focused.
//   /// This decoration is drawn above [decoration].
//   ///
//   /// Defaults to having a rounded rectangle blue border and can be null to have
//   /// no box decoration.
//   final BoxDecoration? focusedDecoration;

//   /// Padding around the text entry area between the [prefix] and [suffix]
//   /// or the clear button when [clearButtonMode] is not never.
//   ///
//   /// Defaults to a padding of 6 pixels on all sides and can be null.
//   final EdgeInsets padding;

//   /// A lighter colored placeholder hint that appears on the first line of the
//   /// text field when the text entry is empty.
//   ///
//   /// Defaults to having no placeholder text.
//   ///
//   /// The text style of the placeholder text matches that of the text field's
//   /// main text entry except a lighter font weight and a grey font color.
//   final String? placeholder;

//   /// The style to use for the placeholder text.
//   ///
//   /// The [placeholderStyle] is merged with the [style] [TextStyle] when applied
//   /// to the [placeholder] text. To avoid merging with [style], specify
//   /// [TextStyle.inherit] as false.
//   ///
//   /// Defaults to the [style] property with w300 font weight and grey color.
//   ///
//   /// If specifically set to null, placeholder's style will be the same as [style].
//   final TextStyle? placeholderStyle;

//   /// The style to use for the text being edited.
//   ///
//   /// Also serves as a base for the [placeholder] text's style.
//   ///
//   /// Defaults to the standard font style from [MacosTheme] if null.
//   final TextStyle? style;

//   /// {@macro flutter.widgets.editableText.textAlign}
//   final TextAlign textAlign;

//   /// {@macro flutter.widgets.editableText.autofocus}
//   final bool autofocus;

//   /// {@macro flutter.widgets.editableText.autocorrect}
//   final bool autocorrect;

//   /// {@macro flutter.services.TextInputConfiguration.enableSuggestions}
//   final bool enableSuggestions;

//   /// {@macro flutter.widgets.editableText.maxLines}
//   final int? maxLines;

//   /// {@macro flutter.widgets.editableText.minLines}
//   final int? minLines;

//   /// {@macro flutter.widgets.editableText.expands}
//   final bool expands;

//   /// The maximum number of characters (Unicode scalar values) to allow in the
//   /// text field.
//   ///
//   /// After [maxLength] characters have been input, additional input
//   /// is ignored, unless [maxLengthEnforcement] is set to
//   /// [MaxLengthEnforcement.none].
//   ///
//   /// The TextField enforces the length with a
//   /// [LengthLimitingTextInputFormatter], which is evaluated after the supplied
//   /// [inputFormatters], if any.
//   ///
//   /// This value must be either null or greater than zero. If set to null
//   /// (the default), there is no limit to the number of characters allowed.
//   ///
//   /// Whitespace characters (e.g. newline, space, tab) are included in the
//   /// character count.
//   ///
//   /// {@macro flutter.services.lengthLimitingTextInputFormatter.maxLength}
//   final int? maxLength;

//   /// Determines how the [maxLength] limit should be enforced.
//   ///
//   /// If [MaxLengthEnforcement.none] is set, additional input beyond [maxLength]
//   /// will not be enforced by the limit.
//   ///
//   /// {@macro flutter.services.textFormatter.effectiveMaxLengthEnforcement}
//   ///
//   /// {@macro flutter.services.textFormatter.maxLengthEnforcement}
//   final MaxLengthEnforcement? maxLengthEnforcement;

//   /// {@macro flutter.widgets.editableText.onChanged}
//   final ValueChanged<String>? onChanged;

//   /// {@macro flutter.widgets.editableText.onEditingComplete}
//   final VoidCallback? onEditingComplete;

//   /// {@macro flutter.widgets.editableText.onSubmitted}
//   ///
//   /// See also:
//   ///
//   ///  * [TextInputAction.next] and [TextInputAction.previous], which
//   ///    automatically shift the focus to the next/previous focusable item when
//   ///    the user is done editing.
//   final ValueChanged<String>? onSubmitted;

//   /// {@macro flutter.widgets.editableText.inputFormatters}
//   final List<TextInputFormatter>? inputFormatters;

//   /// Disables the text field when false.
//   ///
//   /// Text fields in disabled states have a light grey background and don't
//   /// respond to touch events including the [prefix], [suffix] and the clear
//   /// button.
//   final bool? enabled;

//   /// {@macro flutter.material.textfield.onTap}
//   final GestureTapCallback? onTap;

//   @override
//   State<MacosSearchField> createState() => _MacosSearchFieldState();
// }

// class _MacosSearchFieldState extends State<MacosSearchField> {
//   @override
//   Widget build(BuildContext context) {
//     return MacosTextField(
//       prefix: const Padding(
//         padding: EdgeInsets.symmetric(
//           horizontal: 4.0,
//           vertical: 2.0,
//         ),
//         child: MacosIcon(CupertinoIcons.search),
//       ),
//       clearButtonMode: OverlayVisibilityMode.editing,
//       controller: widget.controller,
//       focusNode: widget.focusNode,
//       decoration: widget.decoration,
//       focusedDecoration: widget.focusedDecoration,
//       padding: widget.padding,
//       placeholder: widget.placeholder,
//       placeholderStyle: widget.placeholderStyle,
//       style: widget.style,
//       textAlign: widget.textAlign,
//       autocorrect: widget.autocorrect,
//       autofocus: widget.autofocus,
//       enableSuggestions: widget.enableSuggestions,
//       maxLines: widget.maxLines,
//       minLines: widget.minLines,
//       expands: widget.expands,
//       maxLength: widget.maxLength,
//       maxLengthEnforcement: widget.maxLengthEnforcement,
//       onChanged: widget.onChanged,
//       onEditingComplete: widget.onEditingComplete,
//       onSubmitted: widget.onSubmitted,
//       inputFormatters: widget.inputFormatters,
//       enabled: widget.enabled,
//       onTap: widget.onTap,
//     );
//   }
// }

/// A widget that displays a searchfield and a list of suggestions
/// when the searchfield is brought into focus
class MacosSearchField<T> extends StatefulWidget {
  const MacosSearchField({
    Key? key,
    this.suggestions,
    this.focusNode,
    this.hint,
    this.searchStyle,
    this.controller,
    this.onSubmit,
    this.inputType,
    this.suggestionState = Suggestion.expand,
    this.itemHeight = _kMenuItemHeight,
    this.maxSuggestionsInViewPort = 5,
    this.onSuggestionTap,
    this.emptyWidget = const SizedBox.shrink(),
    this.textInputAction,
    this.suggestionAction,
    this.placeholder,
  }) : super(key: key);

  final FocusNode? focusNode;

  /// List of suggestions for the searchfield.
  /// each suggestion should have a unique searchKey
  ///
  /// ```dart
  /// ['ABC', 'DEF', 'GHI', 'JKL']
  ///   .map((e) => SearchFieldListItem(e, child: Text(e)))
  ///   .toList(),
  /// ```
  final List<SearchFieldListItem<T>>? suggestions;

  /// Callback when the suggestion is selected.
  final Function(SearchFieldListItem<T>)? onSuggestionTap;

  /// Callback when the Searchfield is submitted
  ///  it returns the text from the searchfield
  final Function(String)? onSubmit;

  /// Hint for the [SearchField].
  final String? hint;

  /// Define a [TextInputAction] that is called when the field is submitted
  final TextInputAction? textInputAction;

  /// Specifies [TextStyle] for search input.
  final TextStyle? searchStyle;

  /// defaults to SuggestionState.expand
  final Suggestion suggestionState;

  /// Specifies the [SuggestionAction] called on suggestion tap.
  final SuggestionAction? suggestionAction;

  /// Specifies height for each suggestion item in the list.
  ///
  /// When not specified, the default value is `35.0`.
  final double itemHeight;

  /// Specifies the number of suggestions that can be shown in viewport.
  ///
  /// When not specified, the default value is `5`.
  /// if the number of suggestions is less than 5, then [maxSuggestionsInViewPort]
  /// will be the length of [suggestions]
  final int maxSuggestionsInViewPort;

  /// Specifies the `TextEditingController` for [SearchField].
  final TextEditingController? controller;

  /// Keyboard Type for SearchField
  final TextInputType? inputType;

  /// Widget to show when the search returns
  /// empty results.
  /// defaults to [SizedBox.shrink]
  final Widget emptyWidget;

  final String? placeholder;

  @override
  _MacosSearchFieldState<T> createState() => _MacosSearchFieldState();
}

class _MacosSearchFieldState<T> extends State<MacosSearchField<T>> {
  final StreamController<List<SearchFieldListItem<T>?>?> suggestionStream =
      StreamController<List<SearchFieldListItem<T>?>?>.broadcast();
  FocusNode? _focus;
  bool isSuggestionExpanded = false;
  TextEditingController? searchController;
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  double height = 0.0;
  bool isUp = false;

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
        if (widget.suggestionState == Suggestion.expand) {
          Future.delayed(const Duration(milliseconds: 100), () {
            suggestionStream.sink.add(widget.suggestions);
          });
        }
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
              padding: EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 2.0,
              ),
              child: MacosIcon(CupertinoIcons.search),
            ),
            clearButtonMode: OverlayVisibilityMode.editing,
            onTap: () {
              /// only call if SuggestionState = [Suggestion.expand]
              if (!isSuggestionExpanded &&
                  widget.suggestionState == Suggestion.expand) {
                suggestionStream.sink.add(widget.suggestions);
                if (mounted) {
                  setState(() {
                    isSuggestionExpanded = true;
                  });
                }
              }
            },
            controller: widget.controller ?? searchController,
            focusNode: _focus,
            style: widget.searchStyle,
            textInputAction: widget.textInputAction,
            keyboardType: widget.inputType,
            onChanged: (query) {
              final searchResult = <SearchFieldListItem<T>>[];
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
            },
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
      builder: (context) => StreamBuilder<List<SearchFieldListItem?>?>(
        stream: suggestionStream.stream,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<SearchFieldListItem?>?> snapshot,
        ) {
          late var count = widget.maxSuggestionsInViewPort;
          if (snapshot.data != null) {
            count = snapshot.data!.length;
          }
          return Positioned(
            left: offset.dx,
            width: size.width,
            child: CompositedTransformFollower(
              offset: getYOffset(offset, count),
              link: _layerLink,
              child: _suggestionsBuilder(),
            ),
          );
        },
      ),
    );
  }

  Offset getYOffset(Offset widgetOffset, int resultCount) {
    final size = MediaQuery.of(context).size;
    final position = widgetOffset.dy;
    if ((position + height) < (size.height - widget.itemHeight * 2)) {
      return Offset(0, widget.itemHeight + 10.0);
    } else {
      if (resultCount > widget.maxSuggestionsInViewPort) {
        isUp = false;
        return Offset(
          0,
          -(widget.itemHeight * widget.maxSuggestionsInViewPort),
        );
      } else {
        isUp = true;
        return Offset(0, -(widget.itemHeight * resultCount));
      }
    }
  }

  Widget _suggestionsBuilder() {
    return StreamBuilder<List<SearchFieldListItem<T>?>?>(
      stream: suggestionStream.stream,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<SearchFieldListItem<T>?>?> snapshot,
      ) {
        if (widget.suggestions == null ||
            snapshot.data == null ||
            !isSuggestionExpanded) {
          return const SizedBox.shrink();
        } else if (snapshot.data!.isEmpty) {
          return widget.emptyWidget;
        } else {
          if (snapshot.data!.length > widget.maxSuggestionsInViewPort) {
            height = widget.itemHeight * widget.maxSuggestionsInViewPort;
          } else if (snapshot.data!.length == 1) {
            height = widget.itemHeight;
          } else {
            height = snapshot.data!.length * widget.itemHeight;
          }
          height += 12;
          final brightness = MacosTheme.brightnessOf(context);

          return Container(
            height: height,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: brightness.isDark
                  ? const Color.fromRGBO(30, 30, 30, 1)
                  : const Color.fromRGBO(242, 242, 247, 1),
              boxShadow: [
                BoxShadow(
                  color: brightness
                      .resolve(
                        CupertinoColors.systemGrey.color,
                        CupertinoColors.black,
                      )
                      .withOpacity(0.25),
                  offset: const Offset(0, 4),
                  spreadRadius: 4.0,
                  blurRadius: 8.0,
                ),
              ],
              border: Border.all(
                color: brightness.resolve(
                  CupertinoColors.systemGrey3.color,
                  CupertinoColors.systemGrey3.darkColor,
                ),
              ),
              borderRadius: _kBorderRadius,
            ),
            child: ClipRRect(
              borderRadius: _kBorderRadius,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20.0,
                  sigmaY: 20.0,
                ),
                child: ListView.builder(
                  reverse: isUp,
                  padding: const EdgeInsets.all(6.0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => _SearchFieldButton(
                    itemHeight: widget.itemHeight,
                    onPressed: () {
                      searchController!.text = snapshot.data![index]!.searchKey;
                      searchController!.selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: searchController!.text.length,
                        ),
                      );
                      // suggestion action to switch focus to next focus node
                      if (widget.suggestionAction != null) {
                        if (widget.suggestionAction == SuggestionAction.next) {
                          _focus!.nextFocus();
                        } else if (widget.suggestionAction ==
                            SuggestionAction.unfocus) {
                          _focus!.unfocus();
                        }
                      }
                      // hide the suggestions
                      suggestionStream.sink.add(null);
                      if (widget.onSuggestionTap != null) {
                        widget.onSuggestionTap!(snapshot.data![index]!);
                      }
                    },
                    child: snapshot.data![index]!.child ??
                        Text(
                          snapshot.data![index]!.searchKey,
                        ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class SearchFieldListItem<T> {
  const SearchFieldListItem(
    this.searchKey, {
    this.child,
    this.item,
  });

  /// the text based on which the search happens
  final String searchKey;

  /// Custom Object to be associated with each ListItem
  /// see example in [example/lib/country_search.dart](https://github.com/maheshmnj/searchfield/tree/master/example/lib/country_search.dart)
  final T? item;

  /// The widget to be shown in the searchField
  /// if not specified, Text widget with default styling will be used
  final Widget? child;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is SearchFieldListItem &&
            runtimeType == other.runtimeType &&
            searchKey == other.searchKey;
  }

  @override
  int get hashCode => searchKey.hashCode;
}

class _SearchFieldButton extends StatefulWidget {
  const _SearchFieldButton({
    Key? key,
    this.onPressed,
    required this.child,
    required this.itemHeight,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget child;
  final double itemHeight;

  @override
  State<_SearchFieldButton> createState() => _SearchFieldButtonState();
}

class _SearchFieldButtonState extends State<_SearchFieldButton> {
  bool _isHovered = false;

  void _handleFocusChange(bool focused) {
    setState(() {
      if (focused) {
        _isHovered = true;
      } else {
        _isHovered = false;
      }
    });
  }

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
        child: Focus(
          onKey: (FocusNode node, RawKeyEvent event) {
            if (event.logicalKey == LogicalKeyboardKey.enter) {
              widget.onPressed?.call();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          onFocusChange: _handleFocusChange,
          child: Container(
            height: widget.itemHeight,
            decoration: BoxDecoration(
              color: _isHovered
                  ? MacosPulldownButtonTheme.of(context).highlightColor
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
      ),
    );
  }
}
