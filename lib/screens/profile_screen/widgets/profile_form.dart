import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/edit_photo/bloc/edit_photo_bloc.dart';
import 'package:heist/global_widgets/edit_photo/edit_photo.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/profile_screen/bloc/profile_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';


class ProfileForm extends StatefulWidget {
  final Profile _profile;
  final PhotoRepository _photoRepository;
  final PhotoPickerRepository _photoPickerRepository;
  final CustomerBloc _customerBloc;

  ProfileForm({
    required Profile profile,
    required PhotoRepository photoRepository,
    required PhotoPickerRepository photoPickerRepository,
    required CustomerBloc customerBloc
  })
    : _profile = profile,
      _photoRepository = photoRepository,
      _photoPickerRepository = photoPickerRepository,
      _customerBloc = customerBloc;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late TextEditingController _firstNameController;
  final FocusNode _firstNameFocus = FocusNode();
  late TextEditingController _lastNameController;
  final FocusNode _lastNameFocus = FocusNode();

  bool get isPopulated => _firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty;

  late ProfileFormBloc _profileFormBloc;

  @override
  void initState() {
    super.initState();
    _profileFormBloc = BlocProvider.of<ProfileFormBloc>(context);
    _firstNameController = TextEditingController(text: widget._profile.firstName);
    _lastNameController = TextEditingController(text: widget._profile.lastName);
    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileFormBloc, ProfileFormState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          _showSnackbar(context, state.errorMessage, state);
        } else if (state.isSuccess) {
          _showSnackbar(context, 'Profile Updated!', state);
        }
      },
      child: Form(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: KeyboardActions(
                  config: _buildKeyboard(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      VeryBoldText1(text: 'Edit Profile', context: context),
                      SizedBox(height: SizeConfig.getHeight(6)),
                      Center(
                        child: BlocProvider<EditPhotoBloc>(
                          create: (BuildContext context) => EditPhotoBloc(photoRepository: widget._photoRepository, customerBloc: widget._customerBloc),
                          child: EditPhoto(photoPicker: widget._photoPickerRepository, profile: widget._profile,),
                        )
                      ),
                      SizedBox(height: SizeConfig.getHeight(6)),
                      BlocBuilder<ProfileFormBloc, ProfileFormState>(
                        builder: (context, state) {
                          return TextFormField(
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
                            textInputAction: TextInputAction.done,
                            autocorrect: false,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (_) => !state.isFirstNameValid ? 'Invalid first name' : null,
                          );
                        }
                      ),
                      BlocBuilder<ProfileFormBloc, ProfileFormState>(
                        builder: (context, state) {
                          return TextFormField(
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
                            textInputAction: TextInputAction.done,
                            autocorrect: false,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (_) => !state.isLastNameValid ? 'Invalid last name' : null,
                          );
                        }
                      ),
                      SizedBox(height: SizeConfig.getHeight(10)),
                    ],
                  ),
                ) ,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: BlocBuilder<ProfileFormBloc, ProfileFormState>(
                        builder: (context, state) {
                          return OutlinedButton(
                            onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(context),
                            child: BoldText3(text: 'Cancel', context: context, color: state.isSubmitting 
                              ? Theme.of(context).colorScheme.callToActionDisabled
                              : Theme.of(context).colorScheme.callToAction
                            ),
                          );
                        }
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: BlocBuilder<ProfileFormBloc, ProfileFormState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: _isSaveButtonEnabled(state) ? () => _saveButtonPressed(state) : null,
                            child: _buttonChild(state),
                          );
                        }
                      ) 
                    ),
                  ],
                ),
              ),
            ],
          )
        )
      )
    );
  }
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Widget _buttonChild(ProfileFormState state) {
    if (state.isSubmitting) {
      return SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator());
    } else {
      return BoldText3(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
  }
  
  void _onFirstNameChanged() {
    _profileFormBloc.add(FirstNameChanged(firstName: _firstNameController.text));
  }

  void _onLastNameChanged() {
    _profileFormBloc.add(LastNameChanged(lastName: _lastNameController.text));
  }

  bool _isSaveButtonEnabled(ProfileFormState state) {
    return state.isFormValid && _formFieldsChanged() && isPopulated && !state.isSubmitting;
  }

  bool _formFieldsChanged() {
    return (widget._profile.firstName != _firstNameController.text)
      || (widget._profile.lastName != _lastNameController.text);
  }
  
  void _saveButtonPressed(ProfileFormState state) {
    if (_isSaveButtonEnabled(state)) {
      _profileFormBloc.add(Submitted(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        profileIdentifier: widget._profile.identifier));
    }
  }

  void _cancelButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void _showSnackbar(BuildContext context, String message, ProfileFormState state) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: BoldText3(text: message, context: context, color: Theme.of(context).colorScheme.onSecondary)
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
      .closed.then((_) => {
        if (state.isSuccess) {
          Navigator.of(context).pop()
        } else {
          BlocProvider.of<ProfileFormBloc>(context).add(Reset())
        }
      }
    );
  }

  KeyboardActionsConfig _buildKeyboard(BuildContext context) {
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