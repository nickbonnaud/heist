import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/auth_screen/widgets/cubit/keyboard_visible_cubit.dart';
import 'package:heist/screens/auth_screen/widgets/page_offset_notifier.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';

import 'bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  final PageController _pageController;

  const LoginForm({required PageController pageController, Key? key})
    : _pageController = pageController,
      super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);

    _emailFocus.addListener(keyboardVisibilityChanged);
    _passwordFocus.addListener(keyboardVisibilityChanged);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              _errorLogin(error: state.errorMessage);
            }
          }
        ),

        BlocListener<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (BlocProvider.of<LoginBloc>(context).state.isSuccess) {
              _navigateToNextPage(onboarded: state.onboarded);
            }
          }
        )
      ],
      child: Consumer2<PageOffsetNotifier, AnimationController>(
        builder: (context, notifier, animation, child) {
          return animation.value == 0
          ? Container()
          : Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: (1 - animation.value) * MediaQuery.of(context).size.height + 95.h,
                left: 5.w,
                right: 5.w,
                child: Opacity(
                  opacity: 1 - (2 * notifier.page),
                  child: child,
                )
              ),
            ]
          );
        },
        child: Form(
          key: const Key("loginFormKey"),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _passwordTextField(),
                        SizedBox(height: 25.h),
                        _requestResetPasswordButton()
                      ],
                    ),
                    SizedBox(height: 40.h),
                    _submitButton(),
                    SizedBox(height: 40.h),
                    _goToRegisterButton()
                  ],
                )
              ),
            ) 
          )
        ),
      ) 
    );
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Widget _emailTextField() {
    return BlocBuilder<LoginBloc, LoginState>(
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
            ),
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 25.sp
          ),
        );
      }
    );
  }

  Widget _passwordTextField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("passwordFormFieldKey"),
          focusNode: _passwordFocus,
          keyboardType: TextInputType.text,
          keyboardAppearance: Brightness.light,
          textInputAction: TextInputAction.done,
          onChanged: (password) => _onPasswordChanged(password: password),
          onFieldSubmitted: (_) {
            _passwordFocus.unfocus();
          },
          validator: (_) => !state.isPasswordValid && state.password.isNotEmpty
            ? 'Invalid Password'
            : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autocorrect: false,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary),
            ),
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
      }
    );
  }

  Widget _goToRegisterButton() {
    return Consumer2<PageOffsetNotifier, AnimationController>(
      builder: (context, notifier, animation, child) {
        return TextButton(
          onPressed: () => _goToRegisterButtonPressed(animation: animation), 
          child: Text("Don't have an account?",
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
  
  Widget _requestResetPasswordButton() {
    return TextButton(
      onPressed: () => Navigator.of(context).pushNamed(Routes.requestReset),
      child: Text("Forgot your password?",
        style: TextStyle(
          color: Theme.of(context).colorScheme.callToAction,
          fontSize: 16.sp,
          decoration: TextDecoration.underline,
          letterSpacing: 0.5.w
        )
      ),
    );
  }

  Widget _submitButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return (_isLoginButtonEnabled(state: state) || state.isSubmitting)
        ? Row(
            children: [
              SizedBox(width: .1.sw),
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoginButtonEnabled(state: state)
                    ? () => _submit(state: state)
                    : null,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.onSecondary
                    )
                  ),
                  child: _buttonChild(state: state),
                )
              ) ,
              SizedBox(width: .1.sw),
            ],
          )
        : Container();
      }
    );
  }

  Widget _buttonChild({required LoginState state}) {
    return state.isSubmitting
      ? SizedBox(height: 25.sp, width: 25.sp, child: const CircularProgressIndicator())
      : Text(
          "Login",
          key: const Key("loginButtonTextKey"),
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: 23.sp
          ),
        );
  }

  bool _isLoginButtonEnabled({required LoginState state}) {
    return state.isFormValid && !state.isSubmitting;
  }

  void keyboardVisibilityChanged() {
    final bool keyboardVisible = _emailFocus.hasFocus || _passwordFocus.hasFocus;
    context.read<KeyboardVisibleCubit>().toggle(isVisible: keyboardVisible);
  }
  
  void _onEmailChanged({required String email}) {
    _loginBloc.add(EmailChanged(email: email));
  }

  void _onPasswordChanged({required String password}) {
    _loginBloc.add(PasswordChanged(password: password));
  }

  void _changeFocus({required BuildContext context, required FocusNode current, required FocusNode next}) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  void _submit({required LoginState state}) {
    if (_isLoginButtonEnabled(state: state)) {
      _onFormSubmitted();
    }
  }
  
  void _onFormSubmitted() {
    _loginBloc.add(Submitted());
  }

  void _goToRegisterButtonPressed({required AnimationController animation}) {
    if (animation.status != AnimationStatus.dismissed) {
      animation.reverse().then((_) => widget._pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.decelerate));
    } else {
      widget._pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.decelerate);
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
      ]
    );
  }

  void _errorLogin({required String error}) async {
    Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: const Key("errorLoginSnackbarKey"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SnackbarText(text: error)
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) => _loginBloc.add(Reset()));
  }

  void _navigateToNextPage({required bool onboarded}) {
    if (BlocProvider.of<PermissionsBloc>(context).allPermissionsValid && onboarded) {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.onboard);
    }
  }
}