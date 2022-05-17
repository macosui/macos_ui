import 'package:mason/mason.dart';

void run(HookContext context) {
  if (context.vars['use_translucency'] == true) {
    context.vars['hide_native_title_bar'] = true;
  } else {
    context.vars['hide_native_title_bar'] = context.logger.confirm(
        '${styleBold.wrap(lightGreen.wrap('?'))} Hide native window title bar?');
  }
  if (context.vars['add_multi_window'] == true &&
      context.vars['custom_system_menu_bar'] == false) {
    context.vars['multi_window_no_system_menu'] = true;
  } else {
    context.vars['multi_window_no_system_menu'] = false;
  }
}
