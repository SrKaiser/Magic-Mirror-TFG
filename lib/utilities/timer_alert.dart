import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerAlert {
  final BuildContext context;
  Timer inactivityTimer;
  final Duration inactivityDuration;

  TimerAlert({this.context, this.inactivityDuration});

  void resetInactivityTimer() {
    if (inactivityTimer != null) {
      inactivityTimer.cancel();
    }
    inactivityTimer = Timer(inactivityDuration, onInactivityTimeout);
  }

  void cancelInactivityTimer() {
    print('canceled');
    if (inactivityTimer != null) {
      inactivityTimer.cancel();
    }
  }

  void onInactivityTimeout() async {
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
  }
}
