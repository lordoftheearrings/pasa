// import 'package:pasa/core/components/buttons/app_button.dart';
// import 'package:pasa/core/components/messengers/app_snackbar.dart';
// import 'package:pasa/core/components/selectors/app_labeled_checkbox.dart';
// import 'package:pasa/core/components/selectors/date_selector.dart';
// import 'package:pasa/core/components/selectors/gender_radiobuttons.dart';
// import 'package:pasa/core/components/text/app_text.dart';
// import 'package:pasa/core/components/inputfield/inputfield.dart';
// import 'package:pasa/core/constants/app_colors.dart';
// import 'package:pasa/core/constants/app_textstyles.dart';
// import 'package:pasa/core/enums/gender.dart';
// import 'package:pasa/core/exception/exception_messages.dart';
// import 'package:pasa/core/services/user_session_service.dart';
// import 'package:pasa/core/top_level/di.dart';
// import 'package:pasa/feature/auth/bloc/auth_bloc/auth_bloc.dart';
// import 'package:pasa/feature/auth/bloc/auth_bloc/auth_event.dart';
// import 'package:pasa/feature/auth/bloc/auth_bloc/auth_state.dart';
// import 'package:pasa/feature/auth/bloc/signup_bloc/signup_bloc.dart';
// import 'package:pasa/feature/auth/bloc/signup_bloc/signup_event.dart';
// import 'package:pasa/feature/auth/bloc/signup_bloc/signup_state.dart';
// import 'package:pasa/feature/auth/utils/auth_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ProfileCompletionScreen extends StatefulWidget {
//   const ProfileCompletionScreen({super.key});

//   @override
//   State<ProfileCompletionScreen> createState() =>
//       _ProfileCompletionScreenState();
// }

// class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
//   late TextEditingController firstNameController;
//   late TextEditingController middleNameController;
//   late TextEditingController lastNameController;
//   final GlobalKey<FormState> _signupNameFormKey = GlobalKey<FormState>();
//   final sessionService = getIt<UserSessionService>();

//   @override
//   void initState() {
//     super.initState();
//     final signupData = context.read<SignupBloc>().state.signupData;
//     firstNameController = TextEditingController(text: signupData.fname ?? '');
//     middleNameController = TextEditingController(text: signupData.mname ?? '');
//     lastNameController = TextEditingController(text: signupData.lname ?? '');
//   }

//   @override
//   void dispose() {
//     firstNameController.dispose();
//     middleNameController.dispose();
//     lastNameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: AppColors.black,
//       appBar: AppBar(
//         backgroundColor: AppColors.black,
//         title: AppText(
//           label: 'Complete Your Profile',
//           style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
//         ),
//         centerTitle: true,
//         automaticallyImplyLeading: false,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: BlocBuilder<SignupBloc, SignupState>(
//               builder: (context, state) {
//                 final signupData = state.signupData;
//                 return Form(
//                   key: _signupNameFormKey,
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 16.0),
//                       AppText(
//                         label: 'Please enter your name.',
//                         style: AppTextStyles.bodyTextSemiBold,
//                         textAlign: TextAlign.start,
//                       ),
//                       SizedBox(height: 16.0),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: InputField(
//                               labelText: "First Name",
//                               controller: firstNameController,
//                               validator: (value) =>
//                                   AuthHelper.notNullValidation(value),
//                             ),
//                           ),
//                           SizedBox(width: 20.0),
//                           Expanded(
//                             child: InputField(
//                               labelText: signupData.hasMiddleName == true
//                                   ? "Middle Name"
//                                   : "Last Name",
//                               controller: signupData.hasMiddleName == true
//                                   ? middleNameController
//                                   : lastNameController,
//                               validator: (value) =>
//                                   AuthHelper.notNullValidation(value),
//                             ),
//                           ),
//                         ],
//                       ),
//                       if (signupData.hasMiddleName == true)
//                         Padding(
//                           padding: EdgeInsets.only(
//                             top: 16.0,
//                             right: MediaQuery.of(context).size.width * 0.5 - 8,
//                           ),
//                           child: InputField(
//                             labelText: "Last Name",
//                             controller: lastNameController,
//                             validator: (value) =>
//                                 AuthHelper.notNullValidation(value),
//                           ),
//                         ),
//                       SizedBox(height: 8.0),
//                       LabeledCheckbox(
//                         value: signupData.hasMiddleName ?? false,
//                         onChanged: (newValue) {
//                           context.read<SignupBloc>().add(
//                             SignupEvent.updateHasMiddleName(newValue ?? false),
//                           );
//                         },
//                         label: 'Add Middle Name',
//                       ),
//                       Divider(color: AppColors.hint, thickness: 1),
//                       AppText(
//                         label: 'Please select your gender.',
//                         style: AppTextStyles.bodyTextSemiBold,
//                         textAlign: TextAlign.start,
//                       ),
//                       SizedBox(height: 8.0),
//                       BlocBuilder<SignupBloc, SignupState>(
//                         builder: (context, state) {
//                           final selectedGender = signupData.gender == null
//                               ? null
//                               : Gender.values.firstWhere(
//                                   (g) => g.name == signupData.gender,
//                                 );
//                           return GenderSelection(
//                             selected: selectedGender,
//                             onChanged: (gender) {
//                               context.read<SignupBloc>().add(
//                                 SignupEvent.updateGender(gender),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                       Divider(color: AppColors.hint, thickness: 1),
//                       AppText(
//                         label: 'Enter your Date-of-Birth.',
//                         style: AppTextStyles.bodyTextSemiBold,
//                         textAlign: TextAlign.start,
//                       ),
//                       SizedBox(height: 16.0),
//                       BlocBuilder<SignupBloc, SignupState>(
//                         builder: (context, state) {
//                           return DateSelector(
//                             label: 'Date-of-Birth',
//                             selectedDate: state.signupData.dob,
//                             onDateSelected: (value) {
//                               context.read<SignupBloc>().add(
//                                 SignupEvent.updateDob(value),
//                               );
//                             },
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//       bottomSheet: Container(
//         color: AppColors.black,
//         child: Padding(
//           padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
//           child: BlocConsumer<AuthBloc, AuthState>(
//             listener: (context, authstate) {
//               if (authstate is AuthError) {
//                 AppSnackbar.showError(context, authstate.message);
//               }
//             },
//             builder: (context, authstate) {
//               final loading = authstate is AuthLoading;
//               return AppButton(
//                 label: 'Submit',
//                 isLoading: loading,
//                 onPressed: () {
//                   if (!_signupNameFormKey.currentState!.validate()) {
//                     return;
//                   }
//                   final signupData = context
//                       .read<SignupBloc>()
//                       .state
//                       .signupData;
//                   final dob = signupData.dob;
//                   final session = sessionService.currentSession;
//                   context.read<SignupBloc>().add(
//                     SignupEvent.updateName(
//                       fname: firstNameController.text.trim(),
//                       mname: signupData.hasMiddleName == true
//                           ? middleNameController.text.trim()
//                           : null,
//                       lname: lastNameController.text.trim(),
//                     ),
//                   );
//                   if (signupData.gender == null) {
//                     AppSnackbar.showWarning(context, 'Please select a gender');
//                     return;
//                   }
//                   if (dob == null) {
//                     AppSnackbar.showWarning(
//                       context,
//                       'Please select a date of birth',
//                     );
//                     return;
//                   }
//                   if (DateSelector.isUnderage(dob)) {
//                     AppSnackbar.showWarning(
//                       context,
//                       'You must be 18+ to sign up',
//                     );
//                     return;
//                   }
//                   if (session == null) {
//                     AppSnackbar.showError(
//                       context,
//                       ExceptionMessages.userFriendlyMessage,
//                     );
//                     return;
//                   }
//                   context.read<AuthBloc>().add(
//                     AuthEvent.completeSignup(session: session),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
