import 'package:mason/mason.dart';

void run(HookContext context) {
  if (context.vars['use_translucency'] == true) {
    context.vars['hide_native_title_bar'] = true;
  } else {
    context.vars['hide_native_title_bar'] =
        context.logger.confirm('${styleBold.wrap(lightGreen.wrap('?'))} Hide native window title bar?');
  }
}
