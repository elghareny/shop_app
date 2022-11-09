import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';




void navigateTo(context,widget)=>Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context)=>widget,
    ),);
void navigateAndFinis(context,widget)=>Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context)=>widget,
    ),
    (Route<dynamic> route)=>false,
);









Widget defaultButton(
{
  double width= double.infinity,
  Color? backcolor,
  bool isUpperCase = false,
  double radius= 0.0,
  @required String? text,
  @required VoidCallback? function,

}
    )=>Container(
    width: width,
    height: 60.0,
    child: MaterialButton(
      onPressed: function,
    child: Text(isUpperCase ?text!.toUpperCase():text!,
    style: TextStyle(
      color: Colors.white,
      fontSize: 25
    ),),
    ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backcolor,
      ),
);











Widget textField(
{
  bool? isDefaultPassword,
  IconData? suffixIcon,
  TextInputType? keyboardType,
  Function(String?)? onSubmit,
  bool isPassword =false,
  TextInputAction textInputAction=TextInputAction.next,
  VoidCallback? onTap,
  @required IconData? prefixIcon,
  @required TextEditingController? controller,
  @required String? Function(String?)? validate,
  @required String? text,
  VoidCallback? suffixPressed,
}
    )=>TextFormField(
  controller: controller,
  onFieldSubmitted: onSubmit,
  obscureText: isPassword,
  validator: validate,
  onTap: onTap,
  keyboardType: keyboardType,
  textAlign: TextAlign.start,
  textInputAction: textInputAction,
  cursorRadius: Radius.circular(50.0),
  decoration: InputDecoration(
   prefixIcon: Icon(prefixIcon),
   suffixIcon: suffixIcon !=null ?  IconButton(
   onPressed: suffixPressed,
    icon: Icon(suffixIcon)): null,
labelText: text,
labelStyle: TextStyle(fontSize: 18),
border: OutlineInputBorder(),
// border: InputBorder.none,

),
);


















void showToast(
  {
    @required String? text,
    @required ToastStates? state,
  })
{
  Fluttertoast.showToast(
        msg: text!,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(state!),
        textColor: Colors.white,
        fontSize: 16.0
    );
}


enum ToastStates {SUCCESS,ERROR,WARNING}

Color chooseToastColor (ToastStates state)
{
  Color color;
  switch(state)
  {
    case ToastStates.SUCCESS:
    color = Colors.green;
    break;
    case ToastStates.ERROR:
    color = Colors.red;
    break;
    case ToastStates.WARNING:
    color = Colors.amber;
    break;
  }
  return color;

}
