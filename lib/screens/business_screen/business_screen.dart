import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/business/hours.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessScreen extends StatefulWidget {
  final Business _business;

  BusinessScreen({@required Business business})
    : assert(business != null),
      _business = business;

  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> with SingleTickerProviderStateMixin {
  static const String DISMISSIBLE_KEY = "business_dismissible";

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(DISMISSIBLE_KEY),
      direction: DismissDirection.down,
      onDismissed: (_) => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(widget._business.photos.banner.smallUrl),
                ),
              )
            ),
            Positioned(
              top: 400,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 500,
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    body: Stack(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Container(
                                  height: 4,
                                  color: Colors.grey,
                                  width: MediaQuery.of(context).size.width / 2,
                                ),
                              ),
                              SizedBox(height: 20),
                              BoldText(text: widget._business.profile.name, size: 24.0, color: Colors.black),
                              SizedBox(height: 20),
                              Row(
                                children: <Widget>[
                                  PlatformWidget(
                                    android: (_) => Icon(Icons.public),
                                    ios: (_) => Icon(IconData(0xF4D2,
                                      fontFamily: CupertinoIcons.iconFont,
                                      fontPackage: CupertinoIcons.iconFontPackage
                                    ))
                                  ),
                                  SizedBox(width: 16.0),
                                  GestureDetector(
                                    onTap: () => _navigateToWebsite(),
                                    child: BoldText(text: _formatWebsite(), size: 18.0, color: Colors.orange),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  PlatformWidget(
                                    android: (_) => Icon(Icons.phone),
                                    ios: (_) => Icon(CupertinoIcons.phone),
                                  ),
                                  SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () => launch("tel://${widget._business.profile.phone}"),
                                    child: BoldText(text: _formatPhone(), size: 18.0, color: Colors.orange),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  PlatformWidget(
                                    android: (_) => Icon(Icons.access_time),
                                    ios: (_) => Icon(CupertinoIcons.clock),
                                  ),
                                  SizedBox(width: 16),
                                  BoldText(text: _formatOpenHour(), size: 18.0, color: Colors.orange)
                                ],
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 2,
                                color: Colors.grey.shade100,
                              ),
                              SizedBox(height: 20),
                              BoldText(text: "About ${widget._business.profile.name}", size: 22.0, color: Colors.black),
                              SizedBox(height: 10),
                              NormalText(text: widget._business.profile.description, size: 16.0, color: Colors.black),
                            ],
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
            ),
          ],
        ),
      )
    );
  }

  String _formatWebsite() {
    String url = widget._business.profile.website;
    url = url.replaceAll("http", "");
    if (url.startsWith('s')) {
      url = url.replaceFirst('s', '');
    }
    url = url.replaceAll("://", '');
    if (url.endsWith("/")) {
      url = url.substring(0, url.lastIndexOf("/"));
    }
    return url;
  }
  
  String _formatPhone() {
    String number = widget._business.profile.phone;
    return "(" + number.substring(0,3) + ") " + 
    number.substring(3,6) + "-" +number.substring(6,number.length);
  }

  String _formatOpenHour() {
    int dateInt = DateTime.now().weekday;
    String currentOperatingHours;
    final Hours hours = widget._business.profile.hours;
    switch (dateInt) {
      case 1:
        currentOperatingHours = hours.monday;
        break;
      case 2:
        currentOperatingHours = hours.tuesday;
        break;
      case 3:
        currentOperatingHours = hours.wednesday;
        break;
      case 4:
        currentOperatingHours = hours.thursday;
        break;
      case 5:
        currentOperatingHours = hours.friday;
        break;
      case 6:
        currentOperatingHours = hours.saturday;
        break;
      case 7:
        currentOperatingHours = hours.sunday;
        break;
    }
    return currentOperatingHours;
  }

  void _navigateToWebsite() async {
    if (await canLaunch(widget._business.profile.website)) {
      await launch(widget._business.profile.website);
    } else {
      print('cannot launch url');
    }
  }
}