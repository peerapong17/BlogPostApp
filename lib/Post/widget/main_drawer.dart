import 'package:blogpost/Post/components/drawer_list.dart';
import 'package:blogpost/Post/user_blog.dart';
import 'package:blogpost/utils/show_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main_blog.dart';

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
            () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) {
                  return MainBlog();
                },
              ),
            ),
          ),
          drawerList(
            Icons.person,
            "You post",
            () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) {
                  return UserBlog();
                },
              ),
            ),
          ),
          drawerList(
            Icons.exit_to_app,
            "Log out",
            () => showAlert(context)
          ),
        ],
      ),
    );
  }
}
