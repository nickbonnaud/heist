import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class OnBoardScreen extends StatelessWidget {
  final bool _isLocationEnabled;
  final bool _isNotificationEnabled;

  OnBoardScreen({Key key, @required isLocationEnabled, @required isNotificationEnabled})
  : assert(isLocationEnabled != null && isNotificationEnabled != null),
    _isLocationEnabled = isLocationEnabled,
    _isNotificationEnabled = isNotificationEnabled,
    super(key: key);

  final List<String> _images = [
    "assets/slide_1.png",
    "assets/slide_2.png",
  ];

  final List<String> _headers = [
    "Welcome in your app",
    "Enjoy teaching...",
  ];

  final List<String> _body = [
    "App for food lovers, satisfy your taste",
    "Find best meals in your area, simply",
  ];


  List<Map<String, dynamic>> buttonData = [
    {
      'hasButton': true,
      'buttonText': 'Enable Location Services',
      'action': _requestPermission(PermissionGroup.locationAlways)
    },
    {
      'hasButton': true,
      'buttonText': 'Enable Notifications',
      'action': _requestPermission(PermissionGroup.notification)
    }
  ];
  

  final IndexController controller = IndexController();
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnBoardNavigationBloc>(
      create: (context) => OnBoardNavigationBloc(),
      child: BlocBuilder<OnBoardNavigationBloc, int>(
        builder: (context, index) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: TransformerPageView(
              pageSnapping: true,
              onPageChanged: (index) {
                BlocProvider.of<OnBoardNavigationBloc>(context).add(SlideChanged(index: index));
              },
              loop: false,
              transformer: PageTransformerBuilder(
                builder: (Widget child, TransformInfo info) {
                  return Material(
                    color: Colors.white,
                    elevation: 8.0,
                    textStyle: GoogleFonts.roboto(
                      textStyle: TextStyle(color: Colors.white)
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ParallaxContainer(
                              child: Text(
                                _headers[info.index],
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              ),
                              position: info.position,
                              opacityFactor: 0.8,
                              translationFactor: 400.0,
                            ),
                            SizedBox(height: 25.0),
                            ParallaxContainer(
                              child: Image.asset(
                                _images[info.index],
                                fit: BoxFit.contain,
                                height: 350,
                              ),
                              position: info.position,
                              translationFactor: 400.0,
                            ),
                            SizedBox(height: 25.0),
                            ParallaxContainer(
                              child: Text(
                                _body[info.index],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                              ),
                              position: info.position,
                              translationFactor: 300.0,
                            ),

                            if (buttonData[info.index]['hasButton'])
                              SizedBox(height: 25),
                              ParallaxContainer(
                                child: _buildButton(
                                  buttonData[info.index]['buttonText'],
                                  buttonData[info.index]['action']
                                ),
                                position: info.position,
                                translationFactor: 300.0,
                              ),
                            SizedBox(height: 35),
                            ParallaxContainer(
                              child: Dots(slideIndex: index, numberOfDots: _images.length),
                              position: info.position,
                              translationFactor: 500.0,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } 
              ),
              itemCount: _images.length
            ),
          );
        }
      ),
    );
  }
  
  static Future<bool> _requestPermission(PermissionGroup permission) async {
    Map<PermissionGroup, PermissionStatus> result = 
      await PermissionHandler().requestPermissions([permission]);
    return result[permission] == PermissionStatus.granted;
  }
  
  static _buildButton(String text, Function onPressed) async {
    return PlatformButton(
      child: Text(text),
      onPressed: () => onPressed,
    );
  }
}

class Dots extends StatelessWidget {
  final int _slideIndex;
  final int _numberOfDots;

  Dots({@required slideIndex, @required numberOfDots})
    : assert(slideIndex != null && numberOfDots != null),
      _slideIndex = slideIndex,
      _numberOfDots = numberOfDots;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _generateDots(),
      ),
    );
  }

  List<Widget> _generateDots() {
    List<Widget> dots = [];
    for (int i = 0; i < _numberOfDots; i++) {
      dots.add(i == _slideIndex ? _activeSlide(i) : _inactiveSlide(i));
    }
    return dots;
  }

  Widget _activeSlide(int index) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: Container(
          width: 20.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: Colors.orangeAccent.withOpacity(0.3),
            borderRadius: BorderRadius.circular(50.0)
          ),
        ),
      ),
    );
  }

  Widget _inactiveSlide(int index) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        child: Container(
          width: 14.0,
          height: 14.0,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.7),
            borderRadius: BorderRadius.circular(50.0)
          ),
        ),
      ),
    );
  }
}







class SlideChanged {
  final int index;
  const SlideChanged({@required this.index});
} 

class OnBoardNavigationBloc extends Bloc<SlideChanged, int> {

  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(SlideChanged event) async* {
    if (event is SlideChanged) {
      yield event.index;
    }
  }
}