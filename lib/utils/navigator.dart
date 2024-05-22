import 'package:flutter/material.dart';

navigateTo({context, screen}) {
  Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.5, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCirc;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ));
}

// Remove all previous stack and set new screen as the first screen
navigateAndRemoveUntil({required context, required screen}) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => screen),
      (Route<dynamic> route) => false);
}
