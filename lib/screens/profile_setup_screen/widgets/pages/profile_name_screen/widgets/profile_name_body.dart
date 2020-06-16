import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:heist/screens/profile_setup_screen/widgets/pages/profile_name_screen/widgets/bloc/profile_name_form_bloc.dart';
import 'package:vibrate/vibrate.dart';

class ProfileNameBody extends StatefulWidget {
  final AnimationController _controller;

  ProfileNameBody({@required AnimationController controller})
    : assert(controller != null),
      _controller = controller;

  @override
  State<ProfileNameBody> createState() => _ProfileNameBodyState();
}

class _ProfileNameBodyState extends State<ProfileNameBody> {
  TextEditingController _firstNameController;
  final FocusNode _firstNameFocus = FocusNode();
  TextEditingController _lastNameController;
  final FocusNode _lastNameFocus = FocusNode();

  bool get isPopulated => _firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty;

  ProfileNameFormBloc _profileNameFormBloc;
  
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
        if (state.isFailure) {
          _showSnackbar(context, 'Failed to save. Please try again.', state);
        } else if (state.isSuccess) {
          _showSnackbar(context, 'Great! Your name was saved successfully!', state);
        }
      },
      child: Form(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, bottom: 16, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(height: SizeConfig.getHeight(15)),
                  BoldText.veryBold(
                    text: "Let's start with your name!",
                    size: SizeConfig.getWidth(6),
                    color: Colors.black
                  ),
                  SizedBox(height: SizeConfig.getHeight(10)),
                  BlocBuilder<ProfileNameFormBloc, ProfileNameFormState>(
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
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _firstNameFocus.unfocus();
                          FocusScope.of(context).requestFocus(_lastNameFocus);
                        },
                        autocorrect: false,
                        autovalidate: true,
                        validator: (_) => !state.isFirstNameValid ? 'Invalid first name' : null,
                      );
                    }
                  ),
                  SizedBox(height: SizeConfig.getHeight(3)),
                  BlocBuilder<ProfileNameFormBloc, ProfileNameFormState>(
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
                        onFieldSubmitted: (_) {
                          _lastNameFocus.unfocus();
                        },
                        autocorrect: false,
                        autovalidate: true,
                        validator: (_) => !state.isLastNameValid ? 'Invalid last name' : null,
                      );
                    },
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: BlocBuilder<ProfileNameFormBloc, ProfileNameFormState>(
                      builder: (context, state) {
                        return RaisedButton(
                          color: Colors.green,
                          disabledColor: Colors.green.shade100,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: _isSaveButtonEnabled(state) ? () => _saveButtonPressed(state, context) : null,
                          child: _createButtonText(state),
                        );
                      },
                    )
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
    widget._controller.removeStatusListener(_animationListener); 
    super.dispose();
  }
  
  void _onFirstNameChanged() {
    _profileNameFormBloc.add(FirstNameChanged(firstName: _firstNameController.text));
  }

  void _onLastNameChanged() {
    _profileNameFormBloc.add(LastNameChanged(lastName: _lastNameController.text));
  }

  void _saveButtonPressed(ProfileNameFormState state, BuildContext context) {
    if (_isSaveButtonEnabled(state)) {
      _profileNameFormBloc.add(Submitted(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        customer: BlocProvider.of<AuthenticationBloc>(context).customer));
    }
  }
  
  Widget _createButtonText(ProfileNameFormState state) {
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

  bool _isSaveButtonEnabled(ProfileNameFormState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _showSnackbar(BuildContext context, String message, ProfileNameFormState state) async {
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(state.isSuccess ? FeedbackType.success : FeedbackType.error);
    }

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
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
      ).closed.then((_) {
        if (state.isSuccess) {
          widget._controller.addStatusListener(_animationListener);
          widget._controller.forward();
        } else {
          BlocProvider.of<ProfileNameFormBloc>(context).add(Reset());
        }
      });
  }

  void _animationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      BlocProvider.of<ProfileSetupScreenBloc>(context).add(SectionCompleted(section: Section.name));
    }
  }
}