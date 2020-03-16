import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/screens/home_screen.dart';

import 'login_screen/login_screen.dart';


class SplashScreen extends StatelessWidget {
  final CustomerRepository _customerRepository;

  const SplashScreen({Key key, @required CustomerRepository customerRepository}) 
    : assert(customerRepository != null),
      _customerRepository = customerRepository,
      super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
    return CustomSplash(customerRepository: _customerRepository);
  }
}

class CustomSplash extends StatefulWidget {
  final CustomerRepository _customerRepository;

  const CustomSplash({Key key, @required CustomerRepository customerRepository}) 
    : assert(customerRepository != null),
      _customerRepository = customerRepository,
      super(key: key);

  @override
  _CustomSplashState createState() => _CustomSplashState();
}

class _CustomSplashState extends State<CustomSplash> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200)
    );

    _animation = Tween(
      begin: 0.0,
      end: 1.0
    ).animate(CurvedAnimation(
      parent: _animationController, 
      curve: Curves.easeInCirc
    ));
    
    _animationController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is Authenticated) {
          
          Navigator.of(context).pushReplacement(
            _createRoute(HomeScreen())
          );
        } else if (state is Unauthenticated) {
          Navigator.of(context).pushReplacement(
            _createRoute(LoginScreen(customerRepository: widget._customerRepository))
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _buildAnimation(),
      ) ,
    );
  }

  Route _createRoute(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return new ScaleTransition(
        scale: new Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.00,
                0.50,
                curve: Curves.linear,
              ),
            ),
        ),
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 5.0,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Interval(
                0.50,
                1.00,
                curve: Curves.linear,
              ),
            ),
          ),
          child: child,
        ),
      );
    },
  );
}

  Widget _buildAnimation() {
    switch('zoom-out') {
      case 'fade-in': {
        return FadeTransition(
        opacity: _animation,
        child: Center(
          child:
            SizedBox(height: 200, child: Image.asset('assets/flutter_icon.png'))));
      }
      case 'zoom-in': {
        return ScaleTransition(
        scale: _animation,
        child: Center(
          child:
            SizedBox(height: 200, child: Image.asset('assets/flutter_icon.png'))));
      }
      case 'zoom-out': {
        return ScaleTransition(
        scale: Tween(begin: 1.5, end: 0.6).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInCirc)),
        child: Center(
          child:
            SizedBox(height: 200, child: Image.asset('assets/flutter_icon.png'))));
      }
      case 'top-down': {
        return SizeTransition(
        sizeFactor: _animation,
        child: Center(
          child:
            SizedBox(height: 200, child: Image.asset('assets/flutter_icon.png'))));
      }
    }
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}