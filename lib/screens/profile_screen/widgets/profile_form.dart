import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/global_widgets/edit_photo/bloc/edit_photo_bloc.dart';
import 'package:heist/global_widgets/edit_photo/edit_photo.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/profile_screen/bloc/profile_form_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:vibrate/vibrate.dart';


class ProfileForm extends StatefulWidget {
  final Customer _customer;
  final ProfileRepository _profileRepository;

  ProfileForm({@required Customer customer, @required ProfileRepository profileRepository})
    : assert(customer != null, profileRepository != null),
      _customer = customer,
      _profileRepository = profileRepository;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  TextEditingController _firstNameController;
  final FocusNode _firstNameFocus = FocusNode();
  TextEditingController _lastNameController;
  final FocusNode _lastNameFocus = FocusNode();

  bool get isPopulated => _firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty;

  ProfileFormBloc _profileFormBloc;

  @override
  void initState() {
    super.initState();
    _profileFormBloc = BlocProvider.of<ProfileFormBloc>(context);
    _firstNameController = TextEditingController(text: widget._customer.profile.firstName);
    _lastNameController = TextEditingController(text: widget._customer.profile.lastName);
    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileFormBloc, ProfileFormState>(
      listener: (context, state) {
        if (state.isFailure) {
          _showSnackbar(context, 'Failed to save. Please try again.', state);
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
              Container(
                height: SizeConfig.getHeight(50),
                child: KeyboardActions(
                  config: _buildKeyboard(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      BoldText(text: 'Edit Profile', size: SizeConfig.getWidth(9), color: Colors.black),
                      Center(
                        child: BlocProvider<EditPhotoBloc>(
                          create: (BuildContext context) => EditPhotoBloc(profileRepository: widget._profileRepository , authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
                          child: EditPhoto(photoPicker: PhotoPickerRepository(), customer: widget._customer,),
                        )
                      ),
                      BlocBuilder<ProfileFormBloc, ProfileFormState>(
                        builder: (context, state) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              labelStyle: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: SizeConfig.getWidth(6)
                              )
                            ),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              fontSize: SizeConfig.getWidth(7)
                            ),
                            controller: _firstNameController,
                            focusNode: _firstNameFocus,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            autocorrect: false,
                            autovalidate: true,
                            validator: (_) => !state.isFirstNameValid ? 'Invalid first name' : null,
                          );
                        }
                      ),
                      BlocBuilder<ProfileFormBloc, ProfileFormState>(
                        builder: (context, state) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              labelStyle: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: SizeConfig.getWidth(6)
                              )
                            ),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              fontSize: SizeConfig.getWidth(7)
                            ),
                            controller: _lastNameController,
                            focusNode: _lastNameFocus,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            autocorrect: false,
                            autovalidate: true,
                            validator: (_) => !state.isLastNameValid ? 'Invalid last name' : null,
                          );
                        }
                      )
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
                          return OutlineButton(
                            borderSide: BorderSide(
                              color: Colors.black
                            ),
                            disabledBorderColor: Colors.grey.shade500,
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(context),
                            child: BoldText(text: 'Cancel', size: SizeConfig.getWidth(6), color: state.isSubmitting ? Colors.grey.shade500 : Colors.black),
                          );
                        }
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: BlocBuilder<ProfileFormBloc, ProfileFormState>(
                        builder: (context, state) {
                          return RaisedButton(
                            color: Colors.green,
                            disabledColor: Colors.green.shade100,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                            onPressed: _isSaveButtonEnabled(state) ? () => _saveButtonPressed(state) : null,
                            child: _createButtonText(state),
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

  Widget _createButtonText(ProfileFormState state) {
    if (state.isSubmitting) {
      return TyperAnimatedTextKit(
        speed: Duration(milliseconds: 250),
        text: ['Saving...'],
        textStyle: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: SizeConfig.getWidth(6),
            fontWeight: FontWeight.w700
          ),
          color: Colors.white
        ),
      );
    } else {
      return BoldText(text: 'Save', size: SizeConfig.getWidth(6), color: Colors.white);
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
    return (widget._customer.profile.firstName != _firstNameController.text)
      || (widget._customer.profile.lastName != _lastNameController.text);
  }
  
  void _saveButtonPressed(ProfileFormState state) {
    if (_isSaveButtonEnabled(state)) {
      _profileFormBloc.add(Submitted(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        customer: widget._customer));
    }
  }

  void _cancelButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void _showSnackbar(BuildContext context, String message, ProfileFormState state) async {
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(state.isSuccess ? FeedbackType.success : FeedbackType.error);
    }

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: BoldText(text: message, size: SizeConfig.getWidth(6), color: Colors.white)
              ),
              PlatformWidget(
                android: (_) => Icon(state.isSuccess ? Icons.check_circle_outline : Icons.error),
                ios: (_) => Icon(
                  IconData(
                    state.isSuccess ? 0xF3FE : 0xF35B,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  ),
                  color: Colors.white,
                ),
              )
            ],
          ),
          backgroundColor: state.isSuccess ? Colors.green : Colors.red,
        )
      ).closed.then((_) => {
        if (state.isSuccess) {
          Navigator.of(context).pop()
        } else {
          BlocProvider.of<ProfileFormBloc>(context).add(Reset())
        }
      });
  }

  KeyboardActionsConfig _buildKeyboard(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardAction(
          focusNode: _firstNameFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: BoldText(text: 'Done', size: SizeConfig.getWidth(4), color: Theme.of(context).primaryColor),
                ),
              );
            }
          ]
        ),
        KeyboardAction(
          focusNode: _lastNameFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: BoldText(text: 'Done', size: SizeConfig.getWidth(4), color: Theme.of(context).primaryColor),
                ),
              );
            }
          ]
        ),
      ]
    );
  }
}