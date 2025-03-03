/// Flutter widgets and themes implementing the current macOS design language.
///
/// To use, `import 'package:macos_ui/macos_ui.dart';`
///
/// This library is designed for apps that run on macOS. While it will work on
/// other Flutter-supported platforms, we encourage the use of the following
/// libraries for apps that run on other desktop platforms:
/// * For Windows, [fluent_ui](https://pub.dev/packages/fluent_ui)
/// * For Linux:
///   * [yaru](https://pub.dev/packages/yaru)
///   * [yaru_widgets](https://pub.dev/packages/yaru_widgets)
///   * [yaru_icons](https://pub.dev/packages/yaru_icons)
///   * [yaru_colors](https://pub.dev/packages/yaru_colors)

library macos_ui;

export 'package:macos_window_utils/macos/ns_window_delegate.dart';
export 'package:macos_window_utils/macos_window_utils.dart';

export 'src/buttons/back_button.dart';
export 'src/buttons/checkbox.dart';
export 'src/buttons/disclosure_button.dart';
export 'src/buttons/help_button.dart';
export 'src/buttons/icon_button.dart';
export 'src/buttons/popup_button.dart';
export 'src/buttons/pulldown_button.dart';
export 'src/buttons/push_button.dart';
export 'src/buttons/radio_button.dart';
export 'src/buttons/segmented_control.dart';
export 'src/buttons/switch.dart';
export 'src/buttons/toolbar/toolbar_icon_button.dart';
export 'src/buttons/toolbar/toolbar_overflow_button.dart';
export 'src/buttons/toolbar/toolbar_pulldown_button.dart';
export 'src/dialogs/macos_alert_dialog.dart';
export 'src/enums/control_size.dart';
export 'src/fields/search_field.dart';
export 'src/fields/text_field.dart';
export 'src/icon/image_icon.dart';
export 'src/icon/macos_icon.dart';
export 'src/indicators/capacity_indicators.dart';
export 'src/indicators/progress_indicators.dart';
export 'src/indicators/rating_indicator.dart';
export 'src/indicators/relevance_indicator.dart';
export 'src/indicators/slider.dart';
export 'src/labels/label.dart';
export 'src/labels/tooltip.dart';
export 'src/layout/content_area.dart';
export 'src/layout/macos_list_tile.dart';
export 'src/layout/resizable_pane.dart';
export 'src/layout/scaffold.dart';
export 'src/layout/scrollbar.dart';
export 'src/layout/sidebar/sidebar.dart';
export 'src/layout/sidebar/sidebar_item.dart';
export 'src/layout/sidebar/sidebar_items.dart';
export 'src/layout/tab_view/tab.dart';
export 'src/layout/tab_view/tab_controller.dart';
export 'src/layout/tab_view/tab_view.dart';
export 'src/layout/title_bar.dart';
export 'src/layout/toolbar/custom_toolbar_item.dart';
export 'src/layout/toolbar/sliver_toolbar.dart';
export 'src/layout/toolbar/toolbar.dart';
export 'src/layout/toolbar/toolbar_divider.dart';
export 'src/layout/toolbar/toolbar_overflow_menu.dart';
export 'src/layout/toolbar/toolbar_overflow_menu_item.dart';
export 'src/layout/toolbar/toolbar_popup.dart';
export 'src/layout/toolbar/toolbar_spacer.dart';
export 'src/layout/wallpaper_tinted_area.dart';
export 'src/layout/window.dart';
export 'src/macos_app.dart';
export 'src/macos_window_utils_config.dart';
export 'src/selectors/color_well.dart';
export 'src/selectors/date_picker.dart';
export 'src/selectors/time_picker.dart';
export 'src/sheets/macos_sheet.dart';
export 'src/theme/date_picker_theme.dart';
export 'src/theme/help_button_theme.dart';
export 'src/theme/icon_button_theme.dart';
export 'src/theme/icon_theme.dart';
export 'src/theme/macos_colors.dart';
export 'src/theme/macos_dynamic_color.dart';
export 'src/theme/macos_theme.dart';
export 'src/theme/overlay_filter.dart';
export 'src/theme/popup_button_theme.dart';
export 'src/theme/pulldown_button_theme.dart';
export 'src/theme/push_button_theme.dart';
export 'src/theme/scrollbar_theme.dart';
export 'src/theme/search_field_theme.dart';
export 'src/theme/time_picker_theme.dart';
export 'src/theme/tooltip_theme.dart';
export 'src/theme/typography.dart';
export 'src/enums/accent_color.dart';
export 'src/utils/window_main_state_listener.dart';
export 'src/utils/accent_color_listener.dart';
