import 'package:flutter/material.dart';
import 'package:mappy/bussniesslogic/phone_auth/phone_auth_cubit.dart';
import 'package:mappy/constant/strings.dart';
import 'package:mappy/presentation/screens/log_pin_screen.dart';
import 'package:mappy/presentation/screens/otp_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class AppRouter
{

  PhoneAuthCubit? phoneAuthCubit;
  AppRouter()
  {
    phoneAuthCubit=PhoneAuthCubit();
  }

  Route? getrateRoute(RouteSettings settings)
  {
    switch (settings.name){
      case loginscreen:
        return MaterialPageRoute(
          builder: (context)=>BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
              child: LoginScreen()
          )
        );
      case otpscreen:
        final phonenumber=settings.arguments;
        return MaterialPageRoute(
            builder: (context)=>BlocProvider<PhoneAuthCubit>.value(
              value: phoneAuthCubit!,
               child: OtpScreen(phonenumber:phonenumber),
            )
        );

    }
  }
}