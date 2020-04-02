import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/home_screen/bloc/side_menu_bloc.dart';
import 'package:heist/screens/profile_screen/profile_screen.dart';

class SideDrawer extends StatefulWidget {
  final Widget _homeScreen;

  SideDrawer({@required homeScreen})
    : assert(homeScreen != null),
      _homeScreen = homeScreen;

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> with TickerProviderStateMixin {
  static const String HERO_KEY = 'MENU_KEY';
  
  double _minScale = 0.86;
  double _drawerWidth = 0.66;
  double _shadowBorderRadius = 44.0;
  double _shadowOffset = 16.0;
  double _borderRadius = 32.0;
  bool _disableContentTap = true;
  
  Animation<double> animation, scaleAnimation;
  Animation<BorderRadius> radiusAnimation;
  AnimationController animationController;

  _open(BuildContext context) {
    animationController.forward();
    BlocProvider.of<SideMenuBloc>(context).add(MenuStatusChanged(menuOpen: true));
  }

  _close(BuildContext context) {
    animationController.reverse();
    BlocProvider.of<SideMenuBloc>(context).add(MenuStatusChanged(menuOpen: false));
  }

  _onMenuPressed(BuildContext context, SideMenuState state) {
    state.menuOpened ? _close(context) : _open(context);
  }

  _finishDrawerAnimation(SideMenuState state) {
    if (state.isDraggingMenu) {
      var opened = false;
      BlocProvider.of<SideMenuBloc>(context).add(DraggingMenu(isDragging: false));
      if (animationController.value >= 0.4) {
        animationController.forward();
        opened = true;
      } else {
        animationController.reverse();
      }
      BlocProvider.of<SideMenuBloc>(context).add(MenuStatusChanged(menuOpen: opened));
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(animationController)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });

    radiusAnimation = BorderRadiusTween(begin: BorderRadius.circular(0.0), end: BorderRadius.circular(_borderRadius))
        .animate(CurvedAnimation(parent: animationController, curve: Curves.ease));

    scaleAnimation = Tween<double>(begin: 1.0, end: _minScale).animate(animationController);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SideMenuBloc, SideMenuState>(
      builder: (context, state) {
        return Listener(
          onPointerDown: (PointerDownEvent event) {
            if (_disableContentTap) {
              if (state.menuOpened && event.position.dx / MediaQuery.of(context).size.width >= _drawerWidth) {
                _close(context);
              } else {
                BlocProvider.of<SideMenuBloc>(context).add(DraggingMenu(isDragging: (!state.menuOpened && event.position.dx <= 8.0)));
              }
            } else {
              BlocProvider.of<SideMenuBloc>(context).add(DraggingMenu(isDragging: (state.menuOpened && event.position.dx / MediaQuery.of(context).size.width >= _drawerWidth) || (!state.menuOpened && event.position.dx <= 8.0)));
            }
          },
          onPointerMove: (PointerMoveEvent event) {
            if (state.isDraggingMenu) {
              animationController.value = event.position.dx / MediaQuery.of(context).size.width;
            }
          },
          onPointerUp: (PointerUpEvent event) {
            _finishDrawerAnimation(state);
          },
          onPointerCancel: (PointerCancelEvent event) {
            _finishDrawerAnimation(state);
          },
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                Drawer(),
                Transform.scale(
                  scale: scaleAnimation.value,
                  child: Transform.translate(
                    offset: Offset((MediaQuery.of(context).size.width * _drawerWidth) * animation.value, 0.0),
                    child: AbsorbPointer(
                      absorbing: state.menuOpened && _disableContentTap,
                      child: Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 32.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(_shadowBorderRadius)),
                                    child: Container(
                                      color: Colors.white.withAlpha(128),
                                    ),
                                  ),
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: animation.value * _shadowOffset),
                                child: ClipRRect(
                                  borderRadius: radiusAnimation.value,
                                  child: Container(
                                    color: Colors.white,
                                    child: widget._homeScreen,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            floatingActionButton: !state.menuOpened ? Padding(
              padding: EdgeInsets.only(top: 200),
              child: FloatingActionButton(
                heroTag: HERO_KEY,
                child: PlatformWidget(
                  android: (_) => Icon(Icons.menu),
                  ios: (_) => Icon(IconData(
                    0xF394,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  )),
                ),
                onPressed: () => _onMenuPressed(context, state),
              ),
            ) : null,
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          ),
        );
      }
    );
  }
}

class Drawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.fromRGBO(255, 255, 255, 1.0), Color.fromRGBO(44, 72, 171, 1.0)],
          tileMode: TileMode.repeated,
        )
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 64.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Image.asset(
                    'assets/flutter_icon.png',
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DrawerItem(
                    onPressed: () => print('Pressed'),
                    text: 'Transactions',
                    icon: PlatformWidget(
                      android: (_) => Icon(Icons.receipt),
                      ios: (_) => Icon(IconData(
                        0xF472,
                        fontFamily: CupertinoIcons.iconFont,
                        fontPackage: CupertinoIcons.iconFontPackage
                      )),
                    )
                  ),
                  DrawerItem(
                    onPressed: () => print('pressed'),
                    text: 'Payments',
                    icon: Icon(Icons.payment)
                  ),
                  DrawerItem(
                    onPressed: () => print('pressed'), 
                    text: 'Tutorial', 
                    icon: PlatformWidget(
                      android: (_) => Icon(Icons.lightbulb_outline),
                      ios: (_) => Icon(IconData(
                        0xF451,
                        fontFamily: CupertinoIcons.iconFont,
                        fontPackage: CupertinoIcons.iconFontPackage
                      )),
                    )
                  ),
                  DrawerItem(
                    onPressed: () => showPlatformModalSheet(
                      context: context, 
                      builder: (_) => ProfileScreen()
                    ),
                    text: 'Profile Settings',
                    icon: PlatformWidget(
                      android: (_) => Icon(Icons.person),
                      ios: (_) => Icon(IconData(
                        0xF3A0,
                        fontFamily: CupertinoIcons.iconFont,
                        fontPackage: CupertinoIcons.iconFontPackage
                      )),
                    )
                  ),
                  DrawerItem(
                    onPressed: () => print('pressed'),
                    text: 'Settings',
                    icon: Icon(context.platformIcons.settings)
                  ),
                  DrawerItem(
                    onPressed: () => print('pressed'),
                    text: 'Help',
                    icon: PlatformWidget(
                      android: (_) => Icon(Icons.live_help),
                      ios: (_) => Icon(IconData(
                        0xF445,
                        fontFamily: CupertinoIcons.iconFont,
                        fontPackage: CupertinoIcons.iconFontPackage
                      )),
                    )
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final Function _onPressed;
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
                BoldText(text: _text, size: 18, color: Colors.white)
              ],
            ),
          ),
        ),
      ),
    );
  }
}