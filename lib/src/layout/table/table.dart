import 'package:macos_ui/src/layout/table/table_row.dart';
import 'package:macos_ui/src/library.dart';

/// {@template macosTable}
///
/// {@endtemplate}
class MacosTable extends StatefulWidget {
  /// {@macro macosTable}
  MacosTable({
    super.key,
    this.rows = const <MacosTableRow>[],
    this.onSelectAll,
  })  : assert(() {
          if (rows.any((row1) =>
              row1.key != null &&
              rows.any((row2) => row1 != row2 && row1.key == row2.key))) {
            throw FlutterError(
              'Two or more MacosTableRow cells of this table had the same key.'
              '\nAll the keyed MacosTableRow children of a MacosTable must '
              'have different keys.',
            );
          }
          return true;
        }()),
        assert(() {
          if (rows.isNotEmpty) {
            final cellCount = rows.first.cells.length;
            if (rows.any((row) => row.cells.length != cellCount)) {
              throw FlutterError(
                'Table contains irregular row lengths.\n'
                'Every MacosTableRow in a Table must have the same number of '
                'cells, so that every cell is filled. Otherwise, the table '
                'will contain holes.',
              );
            }
          }
          return true;
        }());

  final List<MacosTableRow> rows;
  final VoidCallback? onSelectAll;

  @override
  State<MacosTable> createState() => _MacosTableState();
}

class _MacosTableState extends State<MacosTable> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
