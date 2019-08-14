import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(1),
      child: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.01, 1],
              colors: [
                Colors.black,
                Colors.deepOrange,
              ]
            ),
          ),
          height: 50,
          width: 50,
          //color: Color.fromRGBO(247, 74, 2, 1),
        ),
      ),
    );
  }
}