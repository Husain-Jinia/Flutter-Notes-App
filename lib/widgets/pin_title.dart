import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class PinTitle extends StatefulWidget {
  final String title;
  final double marginTop;
  const PinTitle({Key? key, required this.title, required this.marginTop}) : super(key: key);

  @override
  State<PinTitle> createState() => _PinTitleState();
}

class _PinTitleState extends State<PinTitle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.marginTop, left: 40, bottom: 5),
      child: Text(widget.title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 107, 107, 107))),
    );
  }
}
