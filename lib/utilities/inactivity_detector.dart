import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:magic_mirror/utilities/router_observer.dart';

mixin InactivityDetectorMixin<T extends StatefulWidget> on State<T>
    implements RouteAware {
  Timer _inactivityTimer;

  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(Duration(seconds: 5), () async {
      // Reproducir sonido de campana
      final player = AudioCache();
      await player.play('audio/bell.mp3');
      // Mostrar alerta
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 8, 54, 85),
            title: Text(
              "Inactivity Alert",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              "What you experience now comes from memory. \n\nTake a few breath, feel your surroundings, and select the icon which best corresponds with the memory you feel.",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPush() {
    _inactivityTimer?.cancel();
  }

  @override
  void didPopNext() {
    _inactivityTimer?.cancel();
  }

  @override
  void didPop() {
    _inactivityTimer?.cancel();
  }

  @override
  void didPushNext() {
    _inactivityTimer?.cancel();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Widget buildInactivityDetector(BuildContext context, Widget child) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _resetTimer,
      onPanDown: (_) => _resetTimer(),
      child: child,
    );
  }
}
