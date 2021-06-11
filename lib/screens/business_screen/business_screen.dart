import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heist/global_widgets/cached_avatar_hero.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/business/hours.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessScreen extends StatefulWidget {
  final Business _business;
  final bool _fromMapScreen;

  BusinessScreen({required Business business, bool fromMapScreen = false})
    : _business = business,
      _fromMapScreen = fromMapScreen;

  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> with SingleTickerProviderStateMixin {
  final key = GlobalKey<_BusinessScreenState>();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      resizeDuration: null,
      dismissThresholds: {
        DismissDirection.down: 0.25
      },
      key: key,
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
                  child: CachedNetworkImage(
                    imageUrl: widget._business.photos.banner.smallUrl,
                    placeholder: (_,__) => Image.memory(kTransparentImage),
                  ),
                ),
              )
            ),
            Positioned(
              top: 100,
              right: 0,
              left: 0,
              child: Align(
                alignment: Alignment.center,
                child: Material(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                  elevation: 5,
                  child: CachedAvatarHero(
                    url: widget._business.photos.logo.smallUrl, 
                    radius: 25, 
                    tag: widget._fromMapScreen
                      ? widget._business.identifier + "-map"
                      : widget._business.identifier, 
                  ),
                ) 
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
                                  color: Theme.of(context).colorScheme.draggableBar,
                                  width: MediaQuery.of(context).size.width / 2,
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  BoldText2(text: widget._business.profile.name, context: context, color: Theme.of(context).colorScheme.primary),
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: Icon(
                                      Icons.arrow_downward,
                                      size: SizeConfig.getWidth(7),
                                      color: Theme.of(context).colorScheme.callToAction,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.public),
                                  SizedBox(width: 16.0),
                                  GestureDetector(
                                    onTap: () => _navigateToWebsite(),
                                    child: BoldText4(text: _formatWebsite(), context: context, color: Theme.of(context).colorScheme.callToAction),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.phone),
                                  SizedBox(width: 16),
                                  GestureDetector(
                                    onTap: () => launch("tel://${widget._business.profile.phone}"),
                                    child: BoldText4(text: _formatPhone(), context: context, color: Theme.of(context).colorScheme.callToAction),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.access_time),
                                  SizedBox(width: 16),
                                  BoldText4(text: _formatOpenHour(), context: context)
                                ],
                              ),
                              SizedBox(height: 20),
                              Container(
                                height: 2,
                                color: Colors.grey.shade100,
                              ),
                              SizedBox(height: 20),
                              BoldText3(text: "About ${widget._business.profile.name}", context: context),
                              SizedBox(height: 10),
                              Text2(text: widget._business.profile.description, context: context, color: Theme.of(context).colorScheme.onPrimarySubdued),
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
      default:
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