import 'package:macos_ui/macos_ui.dart';
import 'package:macos_ui/src/library.dart';

class MacosSearchField extends StatelessWidget {
  const MacosSearchField({
    Key? key,
    this.placeholder,
  }) : super(key: key);

  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    return MacosTextField(
      placeholder: placeholder,
      prefix: const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 4.0,
          vertical: 2.0,
        ),
        child: MacosIcon(CupertinoIcons.search),
      ),
      clearButtonMode: OverlayVisibilityMode.editing,
    );
  }
}
