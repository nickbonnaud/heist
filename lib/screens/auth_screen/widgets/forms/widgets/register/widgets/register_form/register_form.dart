import "dart:math" as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/auth_screen/widgets/cubit/keyboard_visible_cubit.dart';
import 'package:heist/screens/auth_screen/widgets/page_offset_notifier.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

import 'bloc/register_bloc.dart';

class RegisterForm extends StatefulWidget {
  final PageController _pageController;

  RegisterForm({required PageController pageController})
    : _pageController = pageController;
  
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

  late RegisterBloc _registerBloc;
  
  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _passwordConfirmationController.addListener(_onPasswordConfirmationChanged);

    _emailFocus.addListener(keyboardVisibilityChanged);
    _passwordFocus.addListener(keyboardVisibilityChanged);
    _passwordConfirmationFocus.addListener(keyboardVisibilityChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          _errorRegister(error: state.errorMessage);
        } else if (state.isSuccess) {
          _navigateToNextPage();
        }
      },
      child: Consumer2<PageOffsetNotifier, AnimationController>(
        builder: (context, notifier, animation, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: (1 - animation.value) * MediaQuery.of(context).size.height + SizeConfig.getHeight(6),
                left: SizeConfig.getWidth(1),
                right: SizeConfig.getWidth(1),
                child: Opacity(
                  opacity: math.max(0, 4 * notifier.page - 3),
                  child: child,
                )
              ),
              Positioned(
                bottom: animation.value * SizeConfig.getHeight(10) - SizeConfig.getHeight(4),
                child: Consumer2<PageOffsetNotifier, AnimationController>(
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
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.callToAction,
                          fontSize: SizeConfig.getWidth(5),
                          decoration: TextDecoration.underline,
                          letterSpacing: 0.5
                        )
                      ),
                    );
                  }
                )
              )
            ]
          );
        },
        child: Form(
          key: Key("registerFormKey"),
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: KeyboardActions(
                tapOutsideToDismiss: true,
                config: _buildKeyboard(context: context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        return TextFormField(
                          key: Key("emailFormFieldKey"),
                          controller: _emailController,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          keyboardAppearance: Brightness.light,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            _changeFocus(context, _emailFocus, _passwordFocus);
                          },
                          validator: (_) => !state.isEmailValid && _emailController.text.isNotEmpty 
                            ? 'Invalid Email'
                            : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autocorrect: false,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary)
                            ),
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondarySubdued,
                              fontSize: SizeConfig.getWidth(6)
                            )
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: SizeConfig.getWidth(6)
                          ),
                        );
                      },
                    ),
                    SizedBox(height: SizeConfig.getHeight(5)),
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        return TextFormField(
                          key: Key("passwordFormFieldKey"),
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          keyboardType: TextInputType.text,
                          keyboardAppearance: Brightness.light,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            _changeFocus(context, _passwordFocus, _passwordConfirmationFocus);
                          },
                          validator: (_) => !state.isPasswordValid && _passwordController.text.isNotEmpty
                            ? 'Min 8 characters, at least 1 uppercase, 1 number, 1 special character'
                            : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autocorrect: false,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary),
                            ),
                            errorMaxLines: 3,
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondarySubdued,
                              fontSize: SizeConfig.getWidth(6)
                            )
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
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
                          key: Key("passwordConfirmationFormFieldKey"),
                          controller: _passwordConfirmationController,
                          focusNode: _passwordConfirmationFocus,
                          keyboardType: TextInputType.text,
                          keyboardAppearance: Brightness.light,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            _passwordConfirmationFocus.unfocus();
                          },
                          validator: (_) => !state.isPasswordConfirmationValid && _passwordConfirmationController.text.isNotEmpty 
                            ? "Passwords do not match"
                            : null,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          autocorrect: false,
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary)
                            ),
                            hintText: 'Password Confirmation',
                            hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondarySubdued,
                              fontSize: SizeConfig.getWidth(6)
                            )
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
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
                                ? Border.all(color: Theme.of(context).colorScheme.onSecondary)
                                : null,
                              borderRadius: BorderRadius.circular(50)
                            ),
                            child: state.isSubmitting
                              ? SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator())
                              : (_isRegisterButtonEnabled(state)
                                  ? PlatformText(
                                      "Register",
                                      key: Key("registerButtonTextKey"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Theme.of(context).colorScheme.onSecondary,
                                        fontSize: SizeConfig.getWidth(6)
                                      ),
                                    )
                                  : null
                                ),
                          ),
                        );
                      },
                    ),
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

    _emailFocus.dispose();
    _passwordFocus.dispose();
    _passwordConfirmationFocus.dispose();
    super.dispose();
  }

  void keyboardVisibilityChanged() {
    final bool keyboardVisible = _emailFocus.hasFocus || _passwordFocus.hasFocus || _passwordConfirmationFocus.hasFocus;
    context.read<KeyboardVisibleCubit>().toggle(isVisible: keyboardVisible);
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

  KeyboardActionsConfig _buildKeyboard({required BuildContext context}) {
    return KeyboardActionsConfig(
      keyboardBarColor: Theme.of(context).colorScheme.keyboardHelpBarLight,
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardActionsItem(
          focusNode: _emailFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).colorScheme.callToAction),
                ),
              );
            }
          ]
        ),
        KeyboardActionsItem(
          focusNode: _passwordFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).colorScheme.callToAction),
                ),
              );
            }
          ]
        ),
        KeyboardActionsItem(
          focusNode: _passwordConfirmationFocus,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).colorScheme.callToAction),
                ),
              );
            }
          ]
        ),
      ]
    );
  }
  
  void _errorRegister({required String error}) async {
    Vibrate.error();
    final SnackBar snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text3(
              text: error,
              context: context,
              color: Theme.of(context).colorScheme.onError
            )
          )
        ],
      ),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _navigateToNextPage() {
    Navigator.of(context).pushReplacementNamed(Routes.onboard);
  }
}