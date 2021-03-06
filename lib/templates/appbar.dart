import 'package:flutter/material.dart';
import 'package:mup_app/templates/colors.dart';

class MupAppBar extends StatelessWidget with PreferredSizeWidget {
  MupAppBar(this.title, {Key key, this.leadingBackButton, this.actions})
      : preferredSize = Size.fromHeight(70.0),
        super(key: key);

  final String title;

  @override
  final Size preferredSize;
  final bool leadingBackButton;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        this.title,
        textAlign: TextAlign.center,
      ),
      leading: this.leadingBackButton == true
          ? IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : Container(),
      backgroundColor: MupColors.mainTheme,
      elevation: 0,
      actions: this.actions,
    );
  }
}
