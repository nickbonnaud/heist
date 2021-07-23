import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import 'bloc/profile_name_form_bloc.dart';

class ProfileNameBody extends StatefulWidget {

  @override
  State<ProfileNameBody> createState() => _ProfileNameBodyState();
}

class _ProfileNameBodyState extends State<ProfileNameBody> {
  late TextEditingController _firstNameController;
  final FocusNode _firstNameFocus = FocusNode();
  late TextEditingController _lastNameController;
  final FocusNode _lastNameFocus = FocusNode();


  bool get isPopulated => _firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty;

  late ProfileNameFormBloc _profileNameFormBloc;
  
  @override
  void initState() {
    super.initState();
    _profileNameFormBloc = BlocProvider.of<ProfileNameFormBloc>(context);
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
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
          padding: EdgeInsets.only(left: 16.0, bottom: 16, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: KeyboardActions(
                  config: _buildKeyboard(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(height: SizeConfig.getHeight(1)),
                      VeryBoldText4(
                        text: "Let's start with your name!",
                        context: context,
                      ),
                      _firstNameField(),
                      _lastNameTextField(),
                      SizedBox(height: SizeConfig.getHeight(10)),
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _submitButton()
                  )
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
    _firstNameController.dispose();
    _lastNameController.dispose();

    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    super.dispose();
  }

  Widget _firstNameField() {
    return BlocBuilder<ProfileNameFormBloc, ProfileNameFormState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("firstNameFieldKey"),
          decoration: InputDecoration(
            labelText: 'First Name',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.getWidth(6)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.getWidth(7)
          ),
          controller: _firstNameController,
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
          validator: (_) => !state.isFirstNameValid ? 'Invalid first name' : null,
        );
      }
    );
  }

  Widget _lastNameTextField() {
    return BlocBuilder<ProfileNameFormBloc, ProfileNameFormState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("lastNameFieldKey"),
          decoration: InputDecoration(
            labelText: 'Last Name',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.getWidth(6)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.getWidth(7)
          ),
          controller: _lastNameController,
          focusNode: _lastNameFocus,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            _lastNameFocus.unfocus();
          },
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) => !state.isLastNameValid ? 'Invalid last name' : null,
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<ProfileNameFormBloc, ProfileNameFormState>(
      builder: (context, state) {                        
        return ElevatedButton(
          key: Key("submitNameButtonKey"),
          onPressed: _isSaveButtonEnabled(state: state) ? () => _saveButtonPressed(state: state) : null,
          child: _buttonChild(state: state),
        );
      },
    );
  }
  
  void _onFirstNameChanged() {
    _profileNameFormBloc.add(FirstNameChanged(firstName: _firstNameController.text));
  }

  void _onLastNameChanged() {
    _profileNameFormBloc.add(LastNameChanged(lastName: _lastNameController.text));
  }

  void _saveButtonPressed({required ProfileNameFormState state}) {
    if (_isSaveButtonEnabled(state: state)) {
      _profileNameFormBloc.add(Submitted(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text)
      );
    }
  }
  
  Widget _buttonChild({required ProfileNameFormState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator());
    } else {
      return BoldText3(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
  }

  bool _isSaveButtonEnabled({required ProfileNameFormState state}) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _showSnackbar({required String message, required ProfileNameFormState state}) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: Key("nameSnackbarKey"),
      duration: Duration(seconds: 1),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: BoldText4(text: message, context: context, color: Theme.of(context).colorScheme.onSecondary)
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
          BlocProvider.of<ProfileSetupScreenBloc>(context).add(SectionCompleted(section: Section.name));
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
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).primaryColor),
                ),
              );
            }
          ]
        ),
        KeyboardActionsItem(
          focusNode: _lastNameFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).primaryColor),
                ),
              );
            }
          ]
        ),
      ]
    );
  }
}