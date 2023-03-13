import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mappy/bussniesslogic/phone_auth/phone_auth_cubit.dart';
import 'package:mappy/constant/color.dart';
import 'package:mappy/constant/strings.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  late String phonenumber;
  final GlobalKey<FormState> formstate = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formstate,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 32, vertical: 88),
          child: Column(
            children: [
              buildintrotext(),
              SizedBox(
                height: 110,
              ),
              buildPhoneFormfield(),
              SizedBox(
                height: 10,
              ),
              buildnextbutton(context),
              buildphonenumbersubmit(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget buildphonenumbersubmit() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previousstate, current) {
        return previousstate != current;
      },
      listener: (context, state) {
        if (state is PhoneAuthloading) {
          showProgressIndicator(context);

        }
        if(state is PhoneNumberSubmitted)
          {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(otpscreen,arguments: phonenumber);
          }
        if(state is PhoneAutherror)
          {
            Navigator.pop(context);
            String errormsg=(state).errormesg;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errormsg),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 3),
            ));
          }
      },
      child: Container(),
    );
  }

  Widget buildintrotext() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What is your phone number",
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "Please enter your phone number to verify  account",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        )
      ],
    );
  }

  Widget buildPhoneFormfield() {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: MyColors.lightgrey),
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Text(
                generateCounteryFlag() + " +20",
                style: TextStyle(fontSize: 18, letterSpacing: 2.0),
              ),
            )),
        SizedBox(
          width: 16,
        ),
        Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                  border: Border.all(color: MyColors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: TextFormField(
                autofocus: true,
                style: TextStyle(
                  fontSize: 18,
                  letterSpacing: 2.0,
                ),
                decoration: InputDecoration(border: InputBorder.none),
                cursorColor: Colors.black,
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Please enter your Phone number';
                  } else if (val.length < 11) {
                    return 'Please enter correct your Phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  phonenumber = value!;
                },
              ),
            )),
      ],
    );
  }

  String generateCounteryFlag() {
    String counterycode = "eg";
    String flag = counterycode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }

  Widget buildnextbutton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgressIndicator(context);

          register(context);


        },
        child: Text(
          'Next',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
            minimumSize: Size(110, 50),
            primary: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
      ),
    );
  }

  void showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );

    showDialog(
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }
  Future<void> register(BuildContext context)
  async{

    if(!formstate.currentState!.validate())
      {
        Navigator.pop(context);
        return;
      }else
        {
          Navigator.pop(context);
          formstate.currentState!.save();
          BlocProvider.of<PhoneAuthCubit>(context).submitPhoneNumber(phonenumber);
        }

  }
}
