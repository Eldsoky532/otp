import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  late String verificationId;

  PhoneAuthCubit() : super(PhoneAuthInitial());

  Future<void> submitPhoneNumber(String phonenumber) async {
    emit(PhoneAuthloading());

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+2${phonenumber}',
        timeout: const Duration(seconds: 20),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('verificationCompleted');
          await signIn(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('verificationFailed : ${e.toString()}');
          emit(PhoneAutherror(errormesg: e.toString()));
        },
        codeSent: (String verificationId, int? resendcode) {
          print('codeSent');
          this.verificationId = verificationId;
          emit(PhoneNumberSubmitted());
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  Future<void> submitotp(String otpcode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: this.verificationId, smsCode: otpcode);
    await signIn(credential);
  }

  Future<void> signIn(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneOtpVerified());
    } catch (e) {
      emit(PhoneAutherror(errormesg: e.toString()));
    }
  }

  Future<void>logout()
  async{
    await FirebaseAuth.instance.signOut();
  }
  User getloggedInUser()
  {
    User firebaseuser=FirebaseAuth.instance.currentUser!;
    return firebaseuser;
  }
}
