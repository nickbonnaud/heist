import "dart:math" as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/resources/helpers/global_text.dart';
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

  const RegisterForm({required PageController pageController, Key? key})
    : _pageController = pageController,
      super(key: key);
  
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmationFocus = FocusNode();

  late RegisterBloc _registerBloc;
  
  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);

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
                top: (1 - animation.value) * MediaQuery.of(context).size.height + 60.h,
                left: 5.w,
                right: 5.w,
                child: Opacity(
                  opacity: math.max(0, 4 * notifier.page - 3),
                  child: child,
                )
              ),
            ]
          );
        },
        child: Form(
          key: const Key("registerFormKey"),
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: KeyboardActions(
                config: _buildKeyboard(context: context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _emailTextField(),
                    SizedBox(height: 40.h),
                    _passwordTextField(),
                    SizedBox(height: 40.h),
                    _passwordConfirmationTextField(),
                    SizedBox(height: 40.h),
                    _submitButton(),
                    SizedBox(height: 40.h),
                    _goToLoginButton()
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
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _passwordConfirmationFocus.dispose();
    super.dispose();
  }

  Widget _emailTextField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("emailFormFieldKey"),
          focusNode: _emailFocus,
          keyboardType: TextInputType.emailAddress,
          keyboardAppearance: Brightness.light,
          textInputAction: TextInputAction.next,
          onChanged: (email) => _onEmailChanged(email: email),
          onFieldSubmitted: (_) {
            _changeFocus(context: context, current: _emailFocus, next: _passwordFocus);
          },
          validator: (_) => !state.isEmailValid && state.email.isNotEmpty 
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
              fontSize: 25.sp
            )
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 25.sp
          ),
        );
      },
    );
  }

  Widget _passwordTextField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("passwordFormFieldKey"),
          focusNode: _passwordFocus,
          keyboardType: TextInputType.text,
          keyboardAppearance: Brightness.light,
          textInputAction: TextInputAction.next,
          onChanged: (password) => _onPasswordChanged(password: password),
          onFieldSubmitted: (_) {
            _changeFocus(context: context, current: _passwordFocus, next: _passwordConfirmationFocus);
          },
          validator: (_) => !state.isPasswordValid && state.password.isNotEmpty
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
              fontSize: 25.sp
            )
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 25.sp
          ),
          obscureText: true,
        );
      },
    );
  }

  Widget _passwordConfirmationTextField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("passwordConfirmationFormFieldKey"),
          focusNode: _passwordConfirmationFocus,
          keyboardType: TextInputType.text,
          keyboardAppearance: Brightness.light,
          textInputAction: TextInputAction.done,
          onChanged: (passwordConfirmation) => _onPasswordConfirmationChanged(passwordConfirmation: passwordConfirmation),
          onFieldSubmitted: (_) {
            _passwordConfirmationFocus.unfocus();
          },
          validator: (_) => !state.isPasswordConfirmationValid && state.passwordConfirmation.isNotEmpty 
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
              fontSize: 25.sp
            )
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 25.sp
          ),
          obscureText: true,
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return (_isRegisterButtonEnabled(state: state) || state.isSubmitting)
          ? Row(
              children: [
                SizedBox(width: .1.sw),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isRegisterButtonEnabled(state: state)
                      ? () => _submit(state: state)
                      : null,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSecondary
                      )
                    ),
                    child: _buttonChild(state: state)
                  )
                ),
                SizedBox(width: .1.sw),
              ],
            )
          : Container();
      },
    );
  }

  Widget _buttonChild({required RegisterState state}) {
    return state.isSubmitting
      ? SizedBox(height: 25.sp, width: 25.sp, child: const CircularProgressIndicator())
      : Text(
          "Register",
          key: const Key("registerButtonTextKey"),
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 23.sp
          ),
        );
  }

  Widget _goToLoginButton() {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return TextButton(
          onPressed: () => _goToLoginButtonPressed(animation: animation),
          child: Text('Already have an Account?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.callToAction,
              fontSize: 20.sp,
              decoration: TextDecoration.underline,
              letterSpacing: 0.5.w
            )
          )
        );
      }
    );
  }

  void keyboardVisibilityChanged() {
    final bool keyboardVisible = _emailFocus.hasFocus || _passwordFocus.hasFocus || _passwordConfirmationFocus.hasFocus;
    context.read<KeyboardVisibleCubit>().toggle(isVisible: keyboardVisible);
  }

  void _onEmailChanged({required String email}) {
    _registerBloc.add(EmailChanged(email: email));
  }

  void _onPasswordChanged({required String password}) {
    _registerBloc.add(PasswordChanged(password: password));
  }

  void _onPasswordConfirmationChanged({required String passwordConfirmation}) {
    _registerBloc.add(PasswordConfirmationChanged(passwordConfirmation: passwordConfirmation));
  }

  void _changeFocus({required BuildContext context, required FocusNode current, required FocusNode next}) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }
  
  bool _isRegisterButtonEnabled({required RegisterState state}) {
    return state.isFormValid && !state.isSubmitting;
  }

  void _submit({required RegisterState state}) {
    if (_isRegisterButtonEnabled(state: state)) {
      _onFormSubmitted();
    }
  }

  void _onFormSubmitted() {
    _registerBloc.add(Submitted());
  }

  void _goToLoginButtonPressed({required AnimationController animation}) {
    if (animation.status != AnimationStatus.dismissed) {
      animation.reverse().then((_) => widget._pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.decelerate));
    } else {
      widget._pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.decelerate);
    }
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
          focusNode: _passwordFocus,
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
          focusNode: _passwordConfirmationFocus,
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
  
  void _errorRegister({required String error}) async {
    Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: const Key("errorRegisterSnackbarKey"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SnackbarText(text: error)
          )
        ],
      ),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) => _registerBloc.add(Reset()));
  }

  void _navigateToNextPage() {
    Navigator.of(context).pushReplacementNamed(Routes.onboard);
  }
}