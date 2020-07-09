import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/login_screen/bloc/login_bloc.dart';
import 'package:heist/screens/register_screen/register_screen.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:vibrate/vibrate.dart';

class LoginForm extends StatefulWidget {
  final CustomerRepository _customerRepository;

  LoginForm({@required CustomerRepository customerRepository})
    : assert(customerRepository != null),
      _customerRepository = customerRepository;

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
      child: Form(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: KeyboardActions(
            config: _buildKeyboard(context: context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset('assets/logo.png', 
                    height: 30,
                    width: 30,
                    alignment: Alignment.center
                  ),
                ),
                SizedBox(height: SizeConfig.getHeight(1)),
                BoldText1(
                  text: Constants.appName, 
                  context: context,  
                  color: Theme.of(context).colorScheme.textOnDark
                ),
                SizedBox(height: SizeConfig.getHeight(5)),
                TextCustom(
                  text: 'Welcome Back!',
                  context: context,
                  size: SizeConfig.getWidth(7), 
                  color: Theme.of(context).colorScheme.textOnDark
                ),
                SizedBox(height: SizeConfig.getHeight(1)),
                Text2(
                  text: 'Please login to use ${Constants.appName} Pay', 
                  context: context,
                  color: Theme.of(context).colorScheme.textOnDarkSubdued
                ),
                SizedBox(height: SizeConfig.getHeight(5)),
                BlocBuilder<LoginBloc, LoginState>(
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
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.textOnDark,
                        fontSize: SizeConfig.getWidth(6)
                      ),
                    );
                  }
                ),
                SizedBox(height: SizeConfig.getHeight(2)),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        _passwordFocus.unfocus();
                      },
                      validator: (_) => !state.isPasswordValid && _passwordController.text.isNotEmpty ? 'Invalid Password' : null,
                      autovalidate: true,
                      autocorrect: false,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.textOnDark),
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
                        height: SizeConfig.getHeight(6),
                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                        decoration: BoxDecoration(
                          border: (_isLoginButtonEnabled(state) || state.isSubmitting)
                            ? Border.all(color: Theme.of(context).colorScheme.textOnDark)
                            : null,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: state.isSubmitting
                          ? TyperAnimatedTextKit(
                              speed: Duration(milliseconds: 250),
                              text: ['Logging in...'],
                              textStyle: TextStyle(
                                color: Theme.of(context).colorScheme.textOnDark,
                                fontSize: SizeConfig.getWidth(7)
                              ),
                              textAlign: TextAlign.start,
                              alignment: AlignmentDirectional.topStart,
                            )
                          : (_isLoginButtonEnabled(state)
                              ? Text1(text: 'Login', context: context, color: Theme.of(context).colorScheme.textOnDark)
                              : null
                            ),
                      ),
                    );
                  }
                ),
                SizedBox(height: SizeConfig.getHeight(5)),
                GestureDetector(
                  onTap: () {
                    return Navigator.push(
                      context,
                      platformPageRoute(
                        context: context,
                        builder: (_) => RegisterScreen(customerRepository: widget._customerRepository)
                      )
                    );
                  },
                  child: Text("Don't have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.textOnDarkSubdued,
                      fontSize: SizeConfig.getWidth(4),
                      decoration: TextDecoration.underline,
                      letterSpacing: 0.5
                    )
                  ),
                )
              ],
            )
          )
        )
      )
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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