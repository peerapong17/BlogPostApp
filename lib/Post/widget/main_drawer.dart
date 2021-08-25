import 'package:blogpost/Post/component/dialog.dart';
import 'package:blogpost/Post/component/drawer_list.dart';
import 'package:blogpost/Post/user_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main_post.dart';


class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [],
              )),
          drawerList(
            Icons.home,
            "Home",
            () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) {
                    return HomeScreen();
                  },
                ),
              );
            },
          ),
          drawerList(
            Icons.person,
            "You post",
            () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) {
                    return UserPost();
                  },
                ),
              );
            },
          ),
          drawerList(
            Icons.exit_to_app,
            "Log out",
            () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alertDialog(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
