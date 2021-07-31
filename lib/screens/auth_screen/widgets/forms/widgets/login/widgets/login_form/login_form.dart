import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
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
  final PermissionsBloc _permissionsBloc;

  LoginForm({
    required PageController pageController,
    required PermissionsBloc permissionsBloc,
  })
    : _pageController = pageController,
      _permissionsBloc = permissionsBloc;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

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
                top: (1 - animation.value) * MediaQuery.of(context).size.height + SizeConfig.getHeight(12),
                left: SizeConfig.getWidth(1),
                right: SizeConfig.getWidth(1),
                child: Opacity(
                  opacity: 1 - (2 * notifier.page),
                  child: child,
                )
              ),
              Positioned(
                bottom: animation.value * SizeConfig.getHeight(10) - SizeConfig.getHeight(4),
                child: Consumer2<PageOffsetNotifier, AnimationController>(
                  builder: (context, notifier, animation, child) {
                    return _goToRegisterForm(animation: animation);
                  }
                )
              )
            ]
          );
        },
        child: Form(
          key: Key("loginFormKey"),
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
                    _emailTextField(),
                    SizedBox(height: SizeConfig.getHeight(5)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _passwordTextField(),
                        SizedBox(height: SizeConfig.getHeight(3)),
                        _requestResetPasswordButton()
                      ],
                    ),
                    SizedBox(height: SizeConfig.getHeight(5)),
                    _submitButton(),
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
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Widget _emailTextField() {
    return BlocBuilder<LoginBloc, LoginState>(
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
            ),
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: SizeConfig.getWidth(6)
          ),
        );
      }
    );
  }

  Widget _passwordTextField() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("passwordFormFieldKey"),
          controller: _passwordController,
          focusNode: _passwordFocus,
          keyboardType: TextInputType.text,
          keyboardAppearance: Brightness.light,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) {
            _passwordFocus.unfocus();
          },
          validator: (_) => !state.isPasswordValid && _passwordController.text.isNotEmpty
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
              fontSize: SizeConfig.getWidth(6)
            )
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontSize: SizeConfig.getWidth(6)
          ),
          obscureText: true,
        );
      }
    );
  }

  Widget _goToRegisterForm({required AnimationController animation}) {
    return GestureDetector(
      onTap: () {
        if (animation.status != AnimationStatus.dismissed) {
          animation.reverse().then((_) {
            widget._pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.decelerate);
          });
        } else {
          widget._pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.decelerate);
        }
      },
      child: Text("Don't have an account?",
        style: TextStyle(
          color: Theme.of(context).colorScheme.callToAction,
          fontSize: SizeConfig.getWidth(5),
          decoration: TextDecoration.underline,
          letterSpacing: 0.5
        )
      ),
    );
  }
  
  Widget _requestResetPasswordButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(Routes.requestReset),
      child: Text("Forgot your password?",
        style: TextStyle(
          color: Theme.of(context).colorScheme.callToAction,
          fontSize: SizeConfig.getWidth(4),
          decoration: TextDecoration.underline,
          letterSpacing: 0.5
        )
      ),
    );
  }

  Widget _submitButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _submit(state),
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: SizeConfig.getHeight(7),
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
            decoration: BoxDecoration(
              border: (_isLoginButtonEnabled(state) || state.isSubmitting)
                ? Border.all(color: Theme.of(context).colorScheme.onSecondary)
                : null,
              borderRadius: BorderRadius.circular(50),
            ),
            child: state.isSubmitting
              ? SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator())
              : (_isLoginButtonEnabled(state)
                  ? PlatformText(
                      'Login',
                      key: Key("loginButtonTextKey"),
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
      }
    );
  }

  void keyboardVisibilityChanged() {
    final bool keyboardVisible = _emailFocus.hasFocus || _passwordFocus.hasFocus;
    context.read<KeyboardVisibleCubit>().toggle(isVisible: keyboardVisible);
  }
  
  void _onEmailChanged() {
    _loginBloc.add(EmailChanged(email: _emailController.text));
  }

  void _onPasswordChanged() {
    _loginBloc.add(PasswordChanged(password: _passwordController.text));
  }

  void _changeFocus(BuildContext context, FocusNode current, FocusNode next) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  bool _isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _submit(LoginState state) {
    if (_isLoginButtonEnabled(state)) {
      _onFormSubmitted();
    }
  }
  
  void _onFormSubmitted() {
    _loginBloc.add(Submitted(email: _emailController.text, password: _passwordController.text));
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
      ]
    );
  }

  void _errorLogin({required String error}) async {
    Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: Key("errorLoginSnackbarKey"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: BoldText4(
              text: error,
              context: context,
              color: Theme.of(context).colorScheme.onError
            )
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
    if (widget._permissionsBloc.allPermissionsValid && onboarded) {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.onboard);
    }
  }
}