import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/auth_screen/widgets/cubit/keyboard_visible_cubit.dart';
import 'package:heist/screens/auth_screen/widgets/page_offset_notifier.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:vibrate/vibrate.dart';

import 'bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  final PageController _pageController;


  LoginForm({@required PageController pageController})
    : assert(pageController != null),
      _pageController = pageController;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  LoginBloc _loginBloc;

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
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          _errorLogin(context);
        } else if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
            .add(LoggedIn());
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Consumer2<PageOffsetNotifier, AnimationController>(
        builder: (context, notifier, animation, child) {
          return Stack(
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
                )
              )
            ]
          );
        },
        child: Form(
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
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          keyboardAppearance: Brightness.light,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            _changeFocus(context, _emailFocus, _passwordFocus);
                          },
                          validator: (_) => !state.isEmailValid && _emailController.text.isNotEmpty ? 'Invalid email' : null,
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
                    ),
                    SizedBox(height: SizeConfig.getHeight(5)),
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          keyboardType: TextInputType.text,
                          keyboardAppearance: Brightness.light,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            _passwordFocus.unfocus();
                          },
                          validator: (_) => !state.isPasswordValid && _passwordController.text.isNotEmpty ? 'Invalid Password' : null,
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
                    ),
                    SizedBox(height: SizeConfig.getHeight(5)),
                    BlocBuilder<LoginBloc, LoginState>(
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
                              ? TyperAnimatedTextKit(
                                  speed: Duration(milliseconds: 250),
                                  text: ['Logging in...'],
                                  textStyle: TextStyle(
                                    color: Theme.of(context).colorScheme.onSecondary,
                                    fontSize: SizeConfig.getWidth(7)
                                  ),
                                  textAlign: TextAlign.start,
                                  alignment: AlignmentDirectional.topStart,
                                )
                              : (_isLoginButtonEnabled(state)
                                  ? Text1(text: 'Login', context: context, color: Theme.of(context).colorScheme.onSecondary)
                                  : null
                                ),
                          ),
                        );
                      }
                    ),
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
    super.dispose();
  }

  void keyboardVisibilityChanged() {
    final bool keyboardVisible = _emailFocus.hasFocus || _passwordFocus.hasFocus;
    context.bloc<KeyboardVisibleCubit>().toggle(isVisible: keyboardVisible);
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

  KeyboardActionsConfig _buildKeyboard({@required BuildContext context}) {
    return KeyboardActionsConfig(
      keyboardBarColor: Theme.of(context).colorScheme.keyboardHelpBarLight,
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
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).colorScheme.callToAction),
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
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).colorScheme.callToAction),
                ),
              );
            }
          ]
        ),
      ]
    );
  }

  void _errorLogin(BuildContext context) async {
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
                child: Text3(
                  text: 'Cannot login. Please check your email or password.',
                  context: context,
                  color: Theme.of(context).colorScheme.onError)
              ),
              Icon(Icons.error)
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        )
      );
  }
}