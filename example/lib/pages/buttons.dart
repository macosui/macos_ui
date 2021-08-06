import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:flutter/widgets.dart';

class ButtonsPage extends StatefulWidget {
  @override
  _ButtonsPageState createState() => _ButtonsPageState();
}

class _ButtonsPageState extends State<ButtonsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('MacosBackButton'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MacosBackButton(
                onPressed: () => print('click'),
                fillColor: Colors.transparent,
              ),
              const SizedBox(width: 16.0),
              MacosBackButton(
                onPressed: () => print('click'),
                //fillColor: Colors.transparent,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('MacosIconButton'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MacosIconButton(
                icon: Icon(
                  CupertinoIcons.star_fill,
                  color: Colors.white,
                ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(7),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              MacosIconButton(
                icon: Icon(
                  CupertinoIcons.star_fill,
                  color: Colors.white,
                ),
                shape: BoxShape.circle,
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              MacosIconButton(
                icon: Icon(
                  CupertinoIcons.star_fill,
                  color: Colors.white,
                ),
                backgroundColor: Colors.transparent,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),
          PushButton(
            buttonSize: ButtonSize.large,
            child: Text('large PushButton'),
            onPressed: () {
              MacosWindowScope.of(context).toggleSidebar();
            },
          ),
          const SizedBox(height: 20),
          PushButton(
            buttonSize: ButtonSize.small,
            child: Text('small PushButton'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return MacosScaffold(
                      titleBar: TitleBar(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'New page',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      children: [
                        ContentArea(
                          builder: (context, scrollController) {
                            return Center(
                              child: PushButton(
                                buttonSize: ButtonSize.large,
                                child: Text('Go Back'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
                        ),
                        ResizablePane(
                          minWidth: 180,
                          startWidth: 200,
                          scaffoldBreakpoint: 700,
                          resizableSide: ResizableSide.left,
                          builder: (_, __) {
                            return Center(child: Text('Resizable Pane'));
                          },
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
