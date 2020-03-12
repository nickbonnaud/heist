import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/login/login_bloc.dart';
import 'package:vibrate/vibrate.dart';

class LoginForm extends StatefulWidget {

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
        }
      },
      child: Form(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10,horizontal: 45),
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Column(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      _changeFocus(context, _emailFocus, _passwordFocus);
                    },
                    validator: (_) => !state.isEmailValid && _emailController.text.isNotEmpty ? 'Invalid email' : null,
                    autovalidate: true,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                        fontSize: 20
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      _passwordFocus.unfocus();
                      _submit(state);
                    },
                    validator: (_) => !state.isPasswordValid && _passwordController.text.isNotEmpty ? 'Invalid Password' : null,
                    autovalidate: true,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.white70,
                        fontSize: 20
                      )
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => _submit(state),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      height: 50,
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      decoration: BoxDecoration(
                        border: (_isLoginButtonEnabled(state) || state.isSubmitting)
                          ? Border.all(color: Colors.white)
                          : null,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: state.isSubmitting
                        ? TyperAnimatedTextKit(
                            speed: Duration(milliseconds: 250),
                            text: ['Logging in...'],
                            textStyle: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                fontSize: 24,
                                letterSpacing: 1
                              ),
                              color: Colors.white
                            ),
                            textAlign: TextAlign.start,
                            alignment: AlignmentDirectional.topStart,
                          )
                        : (_isLoginButtonEnabled(state)
                            ? Text('Login',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    letterSpacing: 1
                                  )
                                ),
                              )
                            : null
                          ),
                    ),
                  ),
                ],
              );
            }
          ),
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
                child: Text(
                  'Cannot login. Please check your email or password.',
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