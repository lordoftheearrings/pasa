import 'package:pasa/feature/auth/enums/signup_local_storage_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasa/feature/auth/services/signup_service.dart';
import 'package:pasa/feature/auth/models/signup_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupService signupService;

  SignupBloc(this.signupService) : super(SignupState.initial()) {
    on<LoadInitialData>((event, emit) {
      final data = SignupModel.data(
        name: signupService.getString(SignupKeys.name),
        email: signupService.getString(SignupKeys.email),
        phone: signupService.getString(SignupKeys.phone),
        address: signupService.getString(SignupKeys.address),
        bloodGroup: signupService.getString(SignupKeys.bloodGroup),
        emergencyNote: signupService.getString(SignupKeys.emergencyNote),
        dob: signupService.getSignupDob(),
        gender: signupService.getGender()?.name,
        usePhoneNumber:
            signupService.getBool(SignupKeys.usePhoneNumber) ?? false,
      );
      emit(state.copyWith(signupData: data));
    });

    on<UpdateName>((event, emit) {
      signupService.saveString(SignupKeys.name, event.name);
      emit(
        state.copyWith(
          signupData: state.signupData.copyWith(name: event.name),
        ),
      );
    });

    on<UpdateEmail>((event, emit) {
      signupService.saveString(SignupKeys.email, event.email);
      emit(
        state.copyWith(
          signupData: state.signupData.copyWith(email: event.email),
        ),
      );
    });

    on<UpdatePhone>((event, emit) {
      signupService.saveString(SignupKeys.phone, event.phone);
      emit(
        state.copyWith(
          signupData: state.signupData.copyWith(phone: event.phone),
        ),
      );
    });

    on<UpdateAddress>((event, emit) {
      signupService.saveString(SignupKeys.address, event.address);
      emit(
        state.copyWith(
          signupData: state.signupData.copyWith(address: event.address),
        ),
      );
    });

    on<UpdateBloodGroup>((event, emit) {
      signupService.saveString(SignupKeys.bloodGroup, event.bloodGroup);
      emit(
        state.copyWith(
          signupData: state.signupData.copyWith(bloodGroup: event.bloodGroup),
        ),
      );
    });

    on<UpdateEmergencyNote>((event, emit) {
      signupService.saveString(SignupKeys.emergencyNote, event.emergencyNote);
      emit(
        state.copyWith(
          signupData: state.signupData.copyWith(
            emergencyNote: event.emergencyNote,
          ),
        ),
      );
    });

    on<UpdateGender>((event, emit) {
      signupService.saveGender(event.gender);
      emit(
        state.copyWith(
          signupData: state.signupData.copyWith(gender: event.gender?.name),
        ),
      );
    });

    on<UpdateDob>((event, emit) {
      if (event.dob != null) {
        signupService.saveSignupDob(event.dob!.toIso8601String());
      }
      emit(
        state.copyWith(signupData: state.signupData.copyWith(dob: event.dob)),
      );
    });

    on<UpdateUsePhoneNumber>((event, emit) {
      final value = event.value;
      signupService.saveBool(SignupKeys.usePhoneNumber, event.value);
      if (value) {
        signupService.saveString(SignupKeys.email, '');
        emit(
          state.copyWith(
            signupData: state.signupData.copyWith(
              usePhoneNumber: true,
              email: '',
            ),
          ),
        );
        return;
      } else {
        signupService.saveString(SignupKeys.phone, '');
        emit(
          state.copyWith(
            signupData: state.signupData.copyWith(
              usePhoneNumber: false,
              phone: '',
            ),
          ),
        );
        return;
      }
    });

    on<ClearSignupData>((event, emit) async {
      await signupService.clearSignupData();
      emit(SignupState.initial());
    });

    on<SubmitSignup>((event, emit) {
      emit(state.copyWith(password: event.password));
    });

    on<LaunchEmail>((event, emit) async {
      try {
        final webMailUri = Uri.parse('https://mail.google.com/');
        await launchUrl(webMailUri, mode: LaunchMode.externalApplication);
      } catch (e) {
        emit(state.copyWith(error: 'Could not lanch email'));
      }
    });
  }
}
