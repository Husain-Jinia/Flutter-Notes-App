// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:journaling_app/pages/Journals/home.dart';
import '../pages/Navigation/navigation.dart';
import '../pages/Notifications/fToast_style.dart';
import '../sharedPreferences.dart';
import '../utils/enums.dart';

class RoundedButton extends StatefulWidget {
  final String text;
  final Color textColor;
  TextEditingController controller;
  TextEditingController confirmController;
  TextEditingController nameController;
  bool isPinCreated;
  RoundedButton({
    Key? key,
    required this.text,
    this.textColor = Colors.white,
    required this.controller,
    required this.confirmController,
    required this.nameController,
    required this.isPinCreated
  }) : super(key: key);

  @override
  State<RoundedButton> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
    SharedPreferencesService sharedPreferences = SharedPreferencesService();
    late FToast fToast;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fToast = FToast();
    
  }


  handleSubmit(TextEditingController pin, TextEditingController name) async {
     String? userPin  = await sharedPreferences.getFromSharedPref('user-pin');
     if (widget.isPinCreated == true) {
      if(widget.controller.text == userPin){
      await sharedPreferences.saveToSharedPref("user-pin", widget.controller.text);    
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>  Navigation(),
        ),
      );
      }else{
        fToast.init(context);
        showToast(fToast, "Incorrect pin entered", NotificationStatus.failure);
      }

     } else {
       if (widget.controller.text == widget.confirmController.text && name.text.isNotEmpty) {
         await sharedPreferences.saveToSharedPref("user-pin", widget.controller.text);
         await sharedPreferences.saveToSharedPref("user-name", name.text);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement<void, void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>  Navigation(),
              ),
            );
       }else{
        fToast.init(context);
        showToast(fToast, "Pin field cannot be empty", NotificationStatus.failure);
       }
     }
     
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFF000000)),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 20, horizontal: 40))),
          onPressed: (){
            handleSubmit(widget.controller, widget.nameController);
          },
          child: Text(
            widget.text,
            style: TextStyle(color: widget.textColor),
          ),
        ),
      ),
    );
  }
}
