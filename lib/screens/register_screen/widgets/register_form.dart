import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/screens/register_screen/bloc/register_bloc.dart';
import 'package:vibrate/vibrate.dart';

class RegisterForm extends StatefulWidget {
  
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
          _errorRegister(context);
        }
      },
      child: Form(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 45),
          child: BlocBuilder<RegisterBloc, RegisterState>(
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
                      )
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
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      _changeFocus(context, _passwordFocus, _passwordConfirmationFocus);
                    },
                    validator: (_) => !state.isPasswordValid && _passwordController.text.isNotEmpty ? 'Min 6 characters, at least 1 letter, 1 number.' : null,
                    autovalidate: true,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
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
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordConfirmationController,
                    focusNode: _passwordConfirmationFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      _passwordConfirmationFocus.unfocus();
                      _submit(state);
                    },
                    validator: (_) => !state.isPasswordConfirmationValid && _passwordConfirmationController.text.isNotEmpty ? "Passwords are not matching" : null,
                    autovalidate: true,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)
                      ),
                      hintText: 'Password Confirmation',
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
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                      height: 50,
                      decoration: BoxDecoration(
                        border: (_isRegisterButtonEnabled(state) || state.isSubmitting)
                          ? Border.all(color: Colors.white)
                          : null,
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: state.isSubmitting
                        ? TyperAnimatedTextKit(
                            speed: Duration(milliseconds: 250),
                            text: ['Creating Account...'],
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
                        : (_isRegisterButtonEnabled(state)
                            ? Text('Register',
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
                  )
                ],
              );
            }
          )
        )
      ),
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