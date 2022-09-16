import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class ChangePinFormFields extends StatefulWidget {
  TextEditingController controller;
  final focusNode = FocusNode();

  ChangePinFormFields({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<ChangePinFormFields> createState() => _ChangePinFormFieldsState();
}

class _ChangePinFormFieldsState extends State<ChangePinFormFields> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
      const errorColor = Color.fromRGBO(255, 234, 238, 1);
      const fillColor = Color.fromRGBO(222, 231, 240, .57);
      final defaultPinTheme = PinTheme(
        width: 63,
        height: 63,
        textStyle: TextStyle(fontSize: 22, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
        decoration: BoxDecoration(
          color: fillColor,
          
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.transparent),
        ),
      );
      return
         Center(child: Pinput(
          length: 4,
          controller: widget.controller,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: defaultPinTheme.copyWith(
            height: 68,
            width: 64,
            decoration: defaultPinTheme.decoration?.copyWith(
              border: Border.all(color: Colors.black),
            ),
          ),
          errorPinTheme: defaultPinTheme.copyWith(
            decoration: BoxDecoration(
              color: errorColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
         )
      );
    }
  }
