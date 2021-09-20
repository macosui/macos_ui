import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class ContextMenuPage extends StatefulWidget {
  const ContextMenuPage({ Key? key }) : super(key: key);

  @override
  _ContextMenuPageState createState() => _ContextMenuPageState();
}

class _ContextMenuPageState extends State<ContextMenuPage> {

  String _selectedValue = 'No value is selected.';

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      titleBar: TitleBar(
        title: Text('macOS UI Indicators'),
      ),
      children: [
        ContentArea(builder: (context, scrollController) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            controller: scrollController,
            child: LayoutBuilder(
              builder: (laoutBuilderContext, constraints) {
                return ContextMenuArea<String>(
                  itemSelected: (value) {
                    setState(() {
                      _selectedValue = value ?? 'Value was undefined';
                    });
                  },
                  itemBuilder: (context) {
                    return [
                      ContextMenuItem<String>(
                        label: 'one',
                        value: 'one'
                      ),
                      ContextMenuDivider(),
                      ContextMenuItem<String>(label: 'two', value: 'two'),
                      ContextMenuItem<String>(label: 'null', value: null),
                      ContextMenuItem<String>(label: 'four', value: 'four'),
                    ];
                  },
                  child: Container(
                    width: constraints.maxWidth,
                    height: 500.0,
                    color: Colors.red,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(_selectedValue),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: _InnerContextMenu(),
                        )
                      ],
                    ),
                  )
                );
              },
            ),
          );
        }),
      ],
    );
  }
}

class _InnerContextMenu extends StatefulWidget {
  const _InnerContextMenu({ Key? key }) : super(key: key);

  @override
  __InnerContextMenuState createState() => __InnerContextMenuState();
}

class __InnerContextMenuState extends State<_InnerContextMenu> {

  int? _selectedNumber = null;

  @override
  Widget build(BuildContext context) {
    return ContextMenuArea<int>(
      itemSelected: (value) {
        setState(() {
          _selectedNumber = value;
        });
      },
      itemBuilder: (itemBuilderContext) {
        return [
          ContextMenuItem(label: 'Inner 1', value: 1),
          ContextMenuItem(label: 'Inner 2', value: 2),
          CustomContextMenuItem(),
          ContextMenuItem(label: 'Inner 6', value: 6),
        ];
      },
      child: Container(
        width: 250,
        height: 250,
        color: Colors.green,
        child: Text('Selected Number ${_selectedNumber}'),
      ),
    );
  }
}

class CustomContextMenuItem<T> extends ContextMenuEntry<T> {
  const CustomContextMenuItem({Key? key}) : super(key: key);

  @override
  _CustomContextMenuItemState<T> createState() => _CustomContextMenuItemState<T>();
}

/// [ContextMenuEntry.handleTap] is not used in this state, because we want to have 3 buttons which
/// each should return a seperate value
class _CustomContextMenuItemState<T> extends ContextMenuEntryState<CustomContextMenuItem, T> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          TextButton(onPressed: () {
            Navigator.pop<int>(context, 3);
          }, child: Text('3')),
          TextButton(onPressed: () {
            Navigator.pop<int>(context, 4);
          }, child: Text('4')),
          TextButton(onPressed: () {
            Navigator.pop<int>(context, 5);
          }, child: Text('5'))
        ],
      )
    );
  }
}