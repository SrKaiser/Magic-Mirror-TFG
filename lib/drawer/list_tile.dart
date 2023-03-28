import 'package:flutter/material.dart';

class AppDrawerListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String screen;

  const AppDrawerListTile({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.screen,
  }) : super(key: key);

  void cambiarPantalla(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(screen);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => cambiarPantalla(context),
      child: Container(
        width: 300,
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [Icon(icon, color: Colors.white)],
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
