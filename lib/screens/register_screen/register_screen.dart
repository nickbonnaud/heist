import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/screens/login_screen/login_screen.dart';

import 'bloc/register_bloc.dart';
import 'widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  final CustomerRepository _customerRepository;

  RegisterScreen({Key key, @required CustomerRepository customerRepository})
    : assert(customerRepository != null),
      _customerRepository = customerRepository,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset('assets/background.png', fit: BoxFit.fill),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Image.asset('assets/logo.png',
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(Constants.appName,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          fontSize: 27,
                          color: Colors.white,
                          letterSpacing: 1
                        )
                      ),
                    ),
                    SizedBox(height: 40),
                    Text('Welcome!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                          fontSize: 26
                        )
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Start using ${Constants.appName} today!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.white70,
                              letterSpacing: 1,
                              fontSize: 17
                            )
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30),
                    BlocProvider<RegisterBloc>(
                      create: (context) => RegisterBloc(customerRepository: _customerRepository),
                      child: RegisterForm(),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        return Navigator.pop(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (_) => LoginScreen(customerRepository: _customerRepository)
                          )
                        );
                      },
                      child: Text('Already have an Account?',
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            decoration: TextDecoration.underline,
                            letterSpacing: 0.5
                          )
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}