part of 'phone_auth_cubit.dart';

@immutable
abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthloading extends PhoneAuthState {}


class PhoneAuthloaded extends PhoneAuthState {}

class PhoneAutherror extends PhoneAuthState {
  String errormesg;
  PhoneAutherror({required this.errormesg});

}

class PhoneNumberSubmitted extends PhoneAuthState{}

class PhoneOtpVerified extends PhoneAuthState{}



