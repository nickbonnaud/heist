import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/repositories/account_repository.dart';
import 'package:heist/repositories/authentication_repository.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/repositories/customer_repository.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/repositories/refund_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/help_tickets_screen/help_tickets_screen.dart';
import 'package:heist/screens/historic_transactions_screen/historic_transactions_screen.dart';
import 'package:heist/screens/layout_screen/bloc/side_menu_bloc.dart';
import 'package:heist/screens/refunds_screen/refunds_screen.dart';
import 'package:heist/screens/settings_screen/settings_screen.dart';
import 'package:heist/screens/tutorial_screen/tutorial_screen.dart';
import 'package:heist/themes/global_colors.dart';

class SideDrawer extends StatefulWidget {
  final Widget _homeScreen;
  final TransactionRepository _transactionRepository;
  final BusinessRepository _businessRepository;
  final HelpRepository _helpRepository;
  final RefundRepository _refundRepository;
  final CustomerBloc _customerBloc;
  final ProfileRepository _profileRepository;
  final PhotoRepository _photoRepository;
  final PhotoPickerRepository _photoPickerRepository;
  final CustomerRepository _customerRepository;
  final AccountRepository _accountRepository;
  final AuthenticationRepository _authenticationRepository;

  SideDrawer({
    required Widget homeScreen,
    required TransactionRepository transactionRepository,
    required BusinessRepository businessRepository,
    required HelpRepository helpRepository,
    required RefundRepository refundRepository,
    required CustomerBloc customerBloc,
    required ProfileRepository profileRepository,
    required PhotoRepository photoRepository,
    required PhotoPickerRepository photoPickerRepository,
    required CustomerRepository customerRepository,
    required AccountRepository accountRepository,
    required AuthenticationRepository authenticationRepository
  })
    : _homeScreen = homeScreen,
      _transactionRepository = transactionRepository,
      _businessRepository = businessRepository,
      _helpRepository = helpRepository,
      _refundRepository = refundRepository,
      _customerBloc = customerBloc,
      _profileRepository = profileRepository,
      _photoRepository = photoRepository,
      _photoPickerRepository = photoPickerRepository,
      _customerRepository = customerRepository,
      _accountRepository = accountRepository,
      _authenticationRepository = authenticationRepository;

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> with SingleTickerProviderStateMixin {
  static const String HERO_KEY = 'MENU_KEY';
  static const double _minScale = 0.86;
  static const double _drawerWidth = 0.66;
  static const double _shadowOffset = 16.0;
  static const double _borderRadius = 32.0;
  
  late Animation<double> _animation, _scaleAnimation;
  late Animation<BorderRadius> _radiusAnimation;
  late AnimationController _animationController;

  _open(BuildContext context) {
    _animationController.forward();
    BlocProvider.of<SideMenuBloc>(context).add(MenuStatusChanged(menuOpen: true));
  }

  _close(BuildContext context) {
    _animationController.reverse();
    BlocProvider.of<SideMenuBloc>(context).add(MenuStatusChanged(menuOpen: false));
  }

  _onMenuPressed(BuildContext context, SideMenuState state) {
    state.menuOpened ? _close(context) : _open(context);
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this)
      ..addStatusListener((status) {
        BlocProvider.of<SideMenuBloc>(context).add(MenuStatusChanged(menuOpen: status == AnimationStatus.completed));
      });

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _radiusAnimation = BorderRadiusTween(begin: BorderRadius.circular(0.0), end: BorderRadius.circular(_borderRadius))
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.ease));

    _scaleAnimation = Tween<double>(begin: 1.0, end: _minScale).animate(_animationController);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SideMenuBloc, SideMenuState>(
      builder: (context, state) {
        return Scaffold(
          body: GestureDetector(
            onHorizontalDragUpdate: _handleDragUpdate,
            onHorizontalDragEnd: _handleDragEnd,
            child: _buildBody(state: state)
          ),
          floatingActionButton: state.buttonVisible ? Padding(
            padding: EdgeInsets.only(top: 25, left: 10),
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.callToAction,
              heroTag: HERO_KEY,
              child: Icon(Icons.menu),
              onPressed: () => _onMenuPressed(context, state),
            ),
          ) : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        );
      }
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (details.primaryDelta != null) {
      _animationController.value += details.primaryDelta! / MediaQuery.of(context).size.width;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_animationController.isAnimating ||
        _animationController.status == AnimationStatus.completed) return;
    
    final double flingVelocity =
      details.velocity.pixelsPerSecond.dy / MediaQuery.of(context).size.width;
    if (flingVelocity < 0.0)
      _animationController.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _animationController.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _animationController.fling(
        velocity: _animationController.value < 0.5 ? -2.0 : 2.0);
  }

  Widget _buildBody({required SideMenuState state}) {
    return Stack(
      children: <Widget>[
        Drawer(
          transactionRepository: widget._transactionRepository,
          businessRepository: widget._businessRepository,
          helpRepository: widget._helpRepository,
          refundRepository: widget._refundRepository,
          customerBloc: widget._customerBloc,
          profileRepository: widget._profileRepository,
          photoRepository: widget._photoRepository,
          photoPickerRepository: widget._photoPickerRepository,
          customerRepository: widget._customerRepository,
          accountRepository: widget._accountRepository,
          authenticationRepository: widget._authenticationRepository,
        ),
        Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.translate(
            offset: Offset((MediaQuery.of(context).size.width * _drawerWidth) * _animation.value, 0.0),
            child: AbsorbPointer(
              absorbing: state.menuOpened,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: _animation.value * _shadowOffset),
                    child: Material(
                      borderRadius: _radiusAnimation.value,
                      elevation: _animationController.value * 10,
                      child: ClipRRect(
                        borderRadius: _radiusAnimation.value,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).colorScheme.background,
                          child: widget._homeScreen,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class Drawer extends StatelessWidget {
  final TransactionRepository _transactionRepository;
  final BusinessRepository _businessRepository;
  final HelpRepository _helpRepository;
  final RefundRepository _refundRepository;
  final CustomerBloc _customerBloc;
  final ProfileRepository _profileRepository;
  final PhotoRepository _photoRepository;
  final PhotoPickerRepository _photoPickerRepository;
  final CustomerRepository _customerRepository;
  final AccountRepository _accountRepository;
  final AuthenticationRepository _authenticationRepository;

  Drawer({
    required TransactionRepository transactionRepository,
    required BusinessRepository businessRepository,
    required HelpRepository helpRepository,
    required RefundRepository refundRepository,
    required CustomerBloc customerBloc,
    required ProfileRepository profileRepository,
    required PhotoRepository photoRepository,
    required PhotoPickerRepository photoPickerRepository,
    required CustomerRepository customerRepository,
    required AccountRepository accountRepository,
    required AuthenticationRepository authenticationRepository
  })
    : _transactionRepository = transactionRepository,
      _businessRepository = businessRepository,
      _helpRepository = helpRepository,
      _refundRepository = refundRepository,
      _customerBloc = customerBloc,
      _profileRepository = profileRepository,
      _photoRepository = photoRepository,
      _photoPickerRepository = photoPickerRepository,
      _customerRepository = customerRepository,
      _accountRepository = accountRepository,
      _authenticationRepository = authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.getHeight(8)),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            SizedBox(height: SizeConfig.getHeight(5)),
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Image.asset(
                    'assets/logo.png',
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.getHeight(10)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DrawerItem(
                  onPressed: () => Navigator.push(
                    context, 
                    platformPageRoute(
                      context: context, 
                      builder: (_) => HistoricTransactionsScreen(
                        businessRepository: _businessRepository,
                        transactionRepository: _transactionRepository,
                      )
                    )
                  ), 
                  text: 'Transactions',
                  icon: Icon(
                    Icons.receipt, 
                    color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                DrawerItem(
                  onPressed: () => Navigator.push(
                    context, 
                    platformPageRoute(
                      context: context, 
                      builder: (_) => RefundsScreen(
                        refundRepository: _refundRepository,
                        businessRepository: _businessRepository,
                      )
                    )
                  ), 
                  text: 'Refunds',
                  icon: Icon(
                    Icons.receipt_long,
                    color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                DrawerItem(
                  onPressed: () => Navigator.push(
                    context,
                    platformPageRoute(
                      context: context,
                      builder: (_) => SettingsScreen(
                        customerBloc: _customerBloc,
                        profileRepository: _profileRepository,
                        photoRepository: _photoRepository,
                        photoPickerRepository: _photoPickerRepository,
                        customerRepository: _customerRepository,
                        accountRepository: _accountRepository,
                        authenticationRepository: _authenticationRepository,
                      )
                    )
                  ),
                  text: 'Settings',
                  icon: Icon(
                    Icons.settings, 
                    color: Theme.of(context).colorScheme.secondary
                  )
                ),
                DrawerItem(
                  onPressed: () => showPlatformModalSheet(
                    context: context, 
                    builder: (_) => TutorialScreen()
                  ),
                  text: 'Tutorial', 
                  icon: Icon(
                    Icons.lightbulb,
                    color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                DrawerItem(
                  onPressed: () => Navigator.push(
                    context, 
                    platformPageRoute(
                      context: context, 
                      builder: (_) => HelpTicketsScreen(
                        helpRepository: _helpRepository,
                      )
                    )
                  ),
                  text: 'Help',
                  icon: Icon(
                    Icons.contact_support,
                    color: Theme.of(context).colorScheme.secondary
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final VoidCallback _onPressed;
  final String _text;
  final Widget _icon;

  const DrawerItem({@required onPressed, @required text, @required icon})
    : assert(onPressed != null && text != null && icon != null),
      _onPressed = onPressed,
      _text = text,
      _icon = icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 16.0, right: 8.0),
                  child: _icon,
                ),
                BoldText3(text: _text, context: context, color: Theme.of(context).colorScheme.callToAction)
              ],
            ),
          ),
        ),
      ),
    );
  }
}