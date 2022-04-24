import '../library.dart';

class MacosTab extends StatelessWidget {
  const MacosTab({
    Key? key,
    required this.label,
    required this.onTap,
    this.active = false,
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: (TapDownDetails _) {
        // TODO: Implement highlighted state when pressed down
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        child: Text(label),
      ),
    );
  }
}
