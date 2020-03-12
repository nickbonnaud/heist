import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/blocs/login/login_bloc.dart';
import 'package:heist/forms/login_form.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  final CustomerRepository _customerRepository;

  LoginScreen({Key key, @required CustomerRepository customerRepository})
    : assert(customerRepository != null),
      _customerRepository = customerRepository,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    double _deviceWidth = MediaQuery.of(context).size.width;
    double _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: _deviceWidth,
          height: _deviceHeight,
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
                        alignment: Alignment.center
                      ),
                    ),
                    SizedBox(height: 13),
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
                    Text('Welcome Back!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          letterSpacing: 1
                        )
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Please login to use ${Constants.appName} Pay',
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
                    BlocProvider<LoginBloc>(
                      create: (context) => LoginBloc(customerRepository: _customerRepository),
                      child: LoginForm(),
                    ),
                    
                    GestureDetector(
                      onTap: () {
                        return Navigator.push(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (_) => RegisterScreen(customerRepository: _customerRepository)
                          )
                        );
                      },
                      child: Text("Don't have an account?",
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
      ),
    );
  }
}