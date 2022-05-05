import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'bloc/profile_name_form_bloc.dart';
import '../../widgets/title_text.dart';

class ProfileNameBody extends StatefulWidget {

  const ProfileNameBody({Key? key})
    : super(key: key);
  
  @override
  State<ProfileNameBody> createState() => _ProfileNameBodyState();
}

class _ProfileNameBodyState extends State<ProfileNameBody> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();

  late ProfileNameFormBloc _profileNameFormBloc;
  
  @override
  void initState() {
    super.initState();
    _profileNameFormBloc = BlocProvider.of<ProfileNameFormBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileNameFormBloc, ProfileNameFormState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          _showSnackbar(message: state.errorMessage, state: state);
        } else if (state.isSuccess) {
          _showSnackbar(message: 'Great! Your name was saved successfully!', state: state);
        }
      },
      child: Form(
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, bottom: 16.h, right: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: KeyboardActions(
                  config: _buildKeyboard(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: 10.h),
                      const TitleText(text: "Let's start with your name!"),
                      _firstNameField(),
                      _lastNameTextField(),
                      SizedBox(height: 65.h),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(width: .1.sw),
                  Expanded(
                    child: _submitButton()
                  ),
                  SizedBox(width: .1.sw),
                ],
              )
            ],
          ),
        )
      ),
    );
  }
  
  @override
  void dispose() {
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    super.dispose();
  }

  Widget _firstNameField() {
    return BlocBuilder<ProfileNameFormBloc, ProfileNameFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("firstNameFieldKey"),
          decoration: InputDecoration(
            labelText: 'First Name',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 25.sp
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28.sp
          ),
          onChanged: (firstName) => _onFirstNameChanged(firstName: firstName),
          focusNode: _firstNameFocus,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            _firstNameFocus.unfocus();
            FocusScope.of(context).requestFocus(_lastNameFocus);
          },
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) => !state.isFirstNameValid && state.firstName.isNotEmpty
            ? 'Invalid first name' 
            : null,
        );
      }
    );
  }

  Widget _lastNameTextField() {
    return BlocBuilder<ProfileNameFormBloc, ProfileNameFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("lastNameFieldKey"),
          decoration: InputDecoration(
            labelText: 'Last Name',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 25.sp
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28.sp
          ),
          onChanged: (lastName) => _onLastNameChanged(lastName: lastName),
          focusNode: _lastNameFocus,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            _lastNameFocus.unfocus();
          },
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) => !state.isLastNameValid && state.lastName.isNotEmpty
            ? 'Invalid last name'
            : null,
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<ProfileNameFormBloc, ProfileNameFormState>(
      builder: (context, state) {                        
        return ElevatedButton(
          key: const Key("submitNameButtonKey"),
          onPressed: _isSaveButtonEnabled(state: state) ? () => _saveButtonPressed(state: state) : null,
          child: _buttonChild(state: state),
        );
      },
    );
  }
  
  void _onFirstNameChanged({required String firstName}) {
    _profileNameFormBloc.add(FirstNameChanged(firstName: firstName));
  }

  void _onLastNameChanged({required String lastName}) {
    _profileNameFormBloc.add(LastNameChanged(lastName: lastName));
  }

  void _saveButtonPressed({required ProfileNameFormState state}) {
    if (_isSaveButtonEnabled(state: state)) {
      _profileNameFormBloc.add(Submitted());
    }
  }
  
  Widget _buttonChild({required ProfileNameFormState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: 25.sp, width: 25.sp, child: const CircularProgressIndicator());
    } else {
      return const ButtonText(text: 'Save');
    }
  }

  bool _isSaveButtonEnabled({required ProfileNameFormState state}) {
    return state.isFormValid && !state.isSubmitting;
  }

  void _showSnackbar({required String message, required ProfileNameFormState state}) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: const Key("nameSnackbarKey"),
      duration: const Duration(seconds: 1),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SnackbarText(text: message)
          ),
        ],
      ),
      backgroundColor: state.isSuccess
        ? Theme.of(context).colorScheme.success
        : Theme.of(context).colorScheme.error,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) {
        if (state.isSuccess) {
          BlocProvider.of<ProfileSetupScreenBloc>(context).add(const SectionCompleted(section: Section.name));
        } else {
          BlocProvider.of<ProfileNameFormBloc>(context).add(Reset());
        }
      }
    );
  }

  KeyboardActionsConfig _buildKeyboard() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardActionsItem(
          focusNode: _firstNameFocus,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(), 
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: const ActionText()
                )
              );
            }
          ]
        ),
        KeyboardActionsItem(
          focusNode: _lastNameFocus,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(), 
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: const ActionText()
                )
              );
            }
          ]
        ),
      ]
    );
  }
}