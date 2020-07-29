import "dart:math" as math;

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/auth_screen/widgets/page_offset_notifier.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:vibrate/vibrate.dart';

import 'bloc/register_bloc.dart';

class RegisterForm extends StatefulWidget {
  final PageController _pageController;

  RegisterForm({@required PageController pageController})
    : assert(pageController != null),
      _pageController = pageController;
  
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _passwordConfirmationController = TextEditingController();
  final FocusNode _passwordConfirmationFocus = FocusNode();

  bool get isPopulated => _emailController.text.isNotEmpty
    && _passwordController.text.isNotEmpty
    && _passwordConfirmationController.text.isNotEmpty;

  RegisterBloc _registerBloc;
  
  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _passwordConfirmationController.addListener(_onPasswordConfirmationChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isFailure) {
          _errorRegister(context);
        } else if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
            ..add(Registered(customer: state.customer));
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Consumer2<PageOffsetNotifier, AnimationController>(
        builder: (context, notifier, animation, child) {
          return Positioned(
            top: (1 - animation.value) * MediaQuery.of(context).size.height,
            left: SizeConfig.getWidth(1),
            right: SizeConfig.getWidth(1),
            child: Opacity(
              opacity: math.max(0, 4 * notifier.page - 3),
              child: child,
            )
          );
        },
        child: Form(
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: KeyboardActions(
                config: _buildKeyboard(context: context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        return TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            _changeFocus(context, _emailFocus, _passwordFocus);
                          },
                          validator: (_) => !state.isEmailValid && _emailController.text.isNotEmpty ? 'Invalid email' : null,
                          autovalidate: true,
                          autocorrect: false,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.textOnDark)
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.textOnDarkSubdued,
                              fontSize: SizeConfig.getWidth(6)
                            )
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.textOnDark,
                            fontSize: SizeConfig.getWidth(6)
                          ),
                        );
                      },
                    ),
                    SizedBox(height: SizeConfig.getHeight(5)),
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        return TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            _changeFocus(context, _passwordFocus, _passwordConfirmationFocus);
                          },
                          validator: (_) => !state.isPasswordValid && _passwordController.text.isNotEmpty ? 'Min 6 characters, at least 1 letter, 1 number.' : null,
                          autovalidate: true,
                          autocorrect: false,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.textOnDark)
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.textOnDarkSubdued,
                              fontSize: SizeConfig.getWidth(6)
                            )
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.textOnDark,
                            fontSize: SizeConfig.getWidth(6)
                          ),
                          obscureText: true,
                        );
                      },
                    ),
                    SizedBox(height: SizeConfig.getHeight(5)),
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        return TextFormField(
                          controller: _passwordConfirmationController,
                          focusNode: _passwordConfirmationFocus,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            _passwordConfirmationFocus.unfocus();
                          },
                          validator: (_) => !state.isPasswordConfirmationValid && _passwordConfirmationController.text.isNotEmpty ? "Passwords are not matching" : null,
                          autovalidate: true,
                          autocorrect: false,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.textOnDark)
                            ),
                            hintText: 'Password Confirmation',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.textOnDarkSubdued,
                              fontSize: SizeConfig.getWidth(6)
                            )
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.textOnDark,
                            fontSize: SizeConfig.getWidth(6)
                          ),
                          obscureText: true,
                        );
                      },
                    ),
                    SizedBox(height: SizeConfig.getHeight(5)),
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () => _submit(state),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: SizeConfig.getHeight(7),
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                            decoration: BoxDecoration(
                              border: (_isRegisterButtonEnabled(state) || state.isSubmitting)
                                ? Border.all(color: Theme.of(context).colorScheme.textOnDark)
                                : null,
                              borderRadius: BorderRadius.circular(50)
                            ),
                            child: state.isSubmitting
                              ? TyperAnimatedTextKit(
                                  speed: Duration(milliseconds: 250),
                                  text: ['Creating Account...'],
                                  textStyle: TextStyle(
                                    fontSize: SizeConfig.getWidth(7),
                                    color: Theme.of(context).colorScheme.textOnDark,
                                  ),
                                  textAlign: TextAlign.start,
                                  alignment: AlignmentDirectional.topStart,
                                )
                              : (_isRegisterButtonEnabled(state)
                                  ? Text1(text: 'Register', context: context, color: Theme.of(context).colorScheme.textOnDark)
                                  : null
                                ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: SizeConfig.getHeight(5)),
                    Consumer2<PageOffsetNotifier, AnimationController>(
                      builder: (context, notifier, animation, child) {
                        return GestureDetector(
                          onTap: () {
                            if (animation.status != AnimationStatus.dismissed) {
                              animation.reverse().then((_) {
                                widget._pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.decelerate);
                              });
                            } else {
                              widget._pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.decelerate);
                            }
                          },
                          child: Text('Already have an Account?',
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.textOnDarkSubdued,
                                fontSize: SizeConfig.getWidth(4),
                                decoration: TextDecoration.underline,
                                letterSpacing: 0.5
                              )
                            ),
                          ),
                        );
                      }
                    )
                  ],
                ),
              ),
            ) ,
          ),
        ),
      ) 
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _registerBloc.add(PasswordChanged(password: _passwordController.text, passwordConfirmation: _passwordConfirmationController.text));
  }

  void _onPasswordConfirmationChanged() {
    _registerBloc.add(PasswordConfirmationChanged(passwordConfirmation: _passwordConfirmationController.text, password: _passwordController.text));
  }

  void _changeFocus(BuildContext context, FocusNode current, FocusNode next) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }
  
  bool _isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _submit(RegisterState state) {
    if (_isRegisterButtonEnabled(state)) {
      _onFormSubmitted();
    }
  }

  void _onFormSubmitted() {
    _registerBloc.add(Submitted(email: _emailController.text, password: _passwordController.text, passwordConfirmation: _passwordConfirmationController.text));
  }

  KeyboardActionsConfig _buildKeyboard({@required BuildContext context}) {
    return KeyboardActionsConfig(
      keyboardBarColor: Theme.of(context).colorScheme.keyboardHelpBarOnDark,
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardAction(
          focusNode: _emailFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).colorScheme.primary),
                ),
              );
            }
          ]
        ),
        KeyboardAction(
          focusNode: _passwordFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).colorScheme.primary),
                ),
              );
            }
          ]
        ),
        KeyboardAction(
          focusNode: _passwordConfirmationFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).colorScheme.primary),
                ),
              );
            }
          ]
        ),
      ]
    );
  }
  
  void _errorRegister(BuildContext context) async {
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.error);
    }

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Failed to Register. Please try again.',
                  style: GoogleFonts.roboto(fontSize: 16),
                )
              ),
              Icon(Icons.error)
            ],
          ),
          backgroundColor: Colors.red,
        )
      );
  }
}