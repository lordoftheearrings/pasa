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
        email: signupService.getString(SignupKeys.email),
        phone: signupService.getString(SignupKeys.phone),
        fname: signupService.getString(SignupKeys.fname),
        mname: signupService.getString(SignupKeys.mname),
        lname: signupService.getString(SignupKeys.lname),
        dob: signupService.getSignupDob(),
        gender: signupService.getGender()?.name,
        usePhoneNumber:
            signupService.getBool(SignupKeys.usePhoneNumber) ?? false,
        hasMiddleName: signupService.getBool(SignupKeys.hasMiddleName) ?? false,
      );
      emit(state.copyWith(signupData: data));
    });

    on<UpdateName>((event, emit) {
      signupService.saveString(SignupKeys.fname, event.fname);
      signupService.saveString(SignupKeys.mname, event.mname ?? '');
      signupService.saveString(SignupKeys.lname, event.lname);

      _updateName(
        emit,
        fname: event.fname,
        mname: event.mname,
        lname: event.lname,
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

    on<UpdateHasMiddleName>((event, emit) {
      final value = event.value;
      signupService.saveBool(SignupKeys.hasMiddleName, event.value);

      if (!value) {
        signupService.saveString(SignupKeys.mname, '');

        emit(
          state.copyWith(
            signupData: state.signupData.copyWith(
              hasMiddleName: false,
              mname: '',
            ),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          signupData: state.signupData.copyWith(hasMiddleName: true),
        ),
      );
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

  void _updateName(
    Emitter<SignupState> emit, {
    String? fname,
    String? mname,
    String? lname,
  }) {
    final current = state.signupData;
    final updated = current
        .copyWith(
          fname: fname ?? current.fname,
          mname: mname ?? current.mname,
          lname: lname ?? current.lname,
        )
        .createFullName();
    emit(state.copyWith(signupData: updated));
  }
}
