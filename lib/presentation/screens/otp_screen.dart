import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mappy/bussniesslogic/phone_auth/phone_auth_cubit.dart';
import 'package:mappy/constant/color.dart';
import 'package:mappy/constant/strings.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
class OtpScreen extends StatelessWidget {
   OtpScreen({required this.phonenumber});
  final phonenumber;
  late String otpcode;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 32,vertical: 88),
            child: Column(
              children: [
                buildintrotext(),
                SizedBox(height: 60,),
                buildPinCodeFields(context),
                SizedBox(height: 60,),
                buildnextbutton(context),
                buildverificationBloc()
              ],
            ),
          ),
        )
    );
  }

  Widget buildverificationBloc()
  {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previousstate, current) {
        return previousstate != current;
      },
      listener: (context, state) {
        if (state is PhoneAuthloading) {
          showDialog(
              barrierColor: Colors.white.withOpacity(0),
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  content: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                );
              });
        }
        if(state is PhoneNumberSubmitted)
        {
          Navigator.pop(context);
        //  Navigator.of(context).pushReplacementNamed();
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


   Widget buildintrotext()
   {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text("Verify your phone number",style: TextStyle(
             color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold
         ),),
         SizedBox(height: 30,),
         Container(
           margin: EdgeInsets.symmetric(horizontal: 2),
           child: RichText(
             text:TextSpan(
               text: "Enter your 6 digit code numbers sent to ",
               style: TextStyle(
                 color: Colors.black,fontSize: 18,height: 1.4
               ),
               children:<TextSpan> [
                 TextSpan(
                   text: '$phonenumber',
                   style: TextStyle(
                     color: MyColors.blue
                   )
                 )
               ]
             ) ,
           )
         )
       ],
     );
   }


   Widget  buildnextbutton(BuildContext context)
   {
     return Align(
       alignment: Alignment.centerRight,
       child: ElevatedButton(
         onPressed: (){
           login(context);
         },
         child: Text('Next',
           style: TextStyle(
               color: Colors.white,
               fontSize: 16
           ),
         ),
         style: ElevatedButton.styleFrom(
             minimumSize: Size(110, 50),
             primary: Colors.black,
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(6)
             )
         ),
       ),
     );
   }
   void login(BuildContext context)
   {
     BlocProvider.of<PhoneAuthCubit>(context).submitotp(otpcode);
   }
   Widget buildPinCodeFields(BuildContext context)
   {
     return Container(
       child: PinCodeTextField(
         appContext: context,
         length: 6,
         autoFocus: true,
         obscureText: false,
         cursorColor: Colors.black,
         keyboardType: TextInputType.phone,
         animationType: AnimationType.fade,
         pinTheme: PinTheme(
           shape: PinCodeFieldShape.box,
           borderRadius: BorderRadius.circular(5),
           fieldHeight: 50,
           fieldWidth: 40,
           activeColor: Colors.blue,
           inactiveColor: Colors.blue,
           inactiveFillColor: Colors.white,
           selectedColor: MyColors.blue,
           selectedFillColor: Colors.white,
           activeFillColor: Colors.blue,
         ),
         animationDuration: Duration(milliseconds: 300),
         backgroundColor: Colors.blue.shade50,
         enableActiveFill: true,
         // errorAnimationController: errorcontoller,
         // controller: textedittingcontroller,
         onCompleted: (code){
           otpcode=code;
           print("Completed");
         },
         onChanged: (v){
           print(v);
         },
       ),
     );
   }
}
