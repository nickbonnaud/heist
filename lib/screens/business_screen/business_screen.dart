import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/global_widgets/cached_avatar_hero.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/business/hours.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/transaction_picker_screen/models/transaction_picker_args.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collection/collection.dart';

class BusinessScreen extends StatefulWidget {
  final Business _business;
  final bool _fromMapScreen;

  const BusinessScreen({required Business business, bool fromMapScreen = false, Key? key})
    : _business = business,
      _fromMapScreen = fromMapScreen,
      super(key: key);

  @override
  State<BusinessScreen> createState() => _BusinessScreenState();
}

class _BusinessScreenState extends State<BusinessScreen> with SingleTickerProviderStateMixin {
  final _key = GlobalKey<_BusinessScreenState>();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      resizeDuration: null,
      dismissThresholds: const {
        DismissDirection.down: 0.25
      },
      key: _key,
      direction: DismissDirection.down,
      onDismissed: (_) => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              top: 200.h,
              child: _banner()
            ),
            Positioned(
              top: 100.h,
              right: 0,
              left: 0,
              child: Align(
                alignment: Alignment.center,
                child: _logo()
              )
            ),
            Positioned(
              top: 400.h,
                child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 500.h,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _dragBar(),
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget._business.profile.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28.sp,
                                    ),
                                  )
                                ),
                                _dismissButton()
                              ],
                            ),
                            Expanded(
                              child: _scrollBody()
                            )
                          ],
                        )
                    ),
                  ]
                )
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _banner() {
    return ClipRRect(
      key: const Key("bannerKey"),
      borderRadius: BorderRadius.circular(20.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: CachedNetworkImage(
          imageUrl: widget._business.photos.banner.smallUrl,
          placeholder: (_,__) => Image.memory(kTransparentImage),
        ),
      ),
    );
  }

  Widget _logo() {
    return Material(
      key: const Key("logoKey"),
      color: Colors.transparent,
      shape: const CircleBorder(),
      elevation: 5,
      child: CachedAvatarHero(
        url: widget._business.photos.logo.smallUrl, 
        radius: 100.sp, 
        tag: widget._fromMapScreen
          ? widget._business.identifier + "-map"
          : widget._business.identifier, 
      ),
    );
  }

  Widget _dragBar() {
    return Center(
      key: const Key("dragBarKey"),
      child: Container(
        height: 4.h,
        color: Theme.of(context).colorScheme.draggableBar,
        width: MediaQuery.of(context).size.width / 2,
      ),
    );
  }

  Widget _dismissButton() {
    return IconButton(
      key: const Key("dismissBusinessButtonKey"),
      onPressed: () => Navigator.of(context).pop(),
      icon: Icon(
        Icons.arrow_downward,
        size: 36.sp,
        color: Theme.of(context).colorScheme.callToAction,
      )
    );
  }

  Widget _scrollBody() {
    return SingleChildScrollView(
      key: const Key("scrollBodyKey"),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          _claimTransactionButton(),
          _website(),
          _phone(),
          SizedBox(height: 10.h),
          _hours(),
          SizedBox(height: 20.h),
          Container(
            height: 2.h,
            color: Colors.grey.shade100,
          ),
          SizedBox(height: 20.h),
          Text(
            "About ${widget._business.profile.name}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.sp
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            widget._business.profile.description,
            style: TextStyle(
              fontSize: 18.sp,
              color: Theme.of(context).colorScheme.onPrimarySubdued
            ),
          ),
          SizedBox(height: 90.h)
        ],
      ),
    );
  }
  
  Widget _claimTransactionButton() {
    return BlocBuilder<ActiveLocationBloc, ActiveLocationState>(
      buildWhen: (previousState, currentState) => previousState.activeLocations != currentState.activeLocations,
      builder: (context, state) {
        ActiveLocation? activeLocation = state.activeLocations.firstWhereOrNull((activeLocation) => activeLocation.business == widget._business);
        if (activeLocation == null || activeLocation.transactionIdentifier != null) return Container();
        
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: .05.sw),
                Expanded(
                  child: ElevatedButton(
                    key: const Key("claimTransactionButtonKey"),
                    onPressed: () => _goToTransactionFinderScreen(), 
                    child: const ButtonText(text: "Claim Bill")
                  ),
                ),
                SizedBox(width: .05.sw),
              ],
            ),
            const Divider(),
          ],
        );
      }
    );
  }
  
  Widget _website() {
    return Row(
      children: [
        const Icon(Icons.public),
        SizedBox(width: 16.w),
        TextButton(
          key: const Key("websiteButtonKey"),
          onPressed: () => _navigateToWebsite(),
          child: Text(
            _formatWebsite(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
              color: Theme.of(context).colorScheme.callToAction
            ),
          )
        )
      ],
    );
  }

  Widget _phone() {
    return Row(
      children: [
        const Icon(Icons.phone),
        SizedBox(width: 16.w),
        TextButton(
          key: const Key("phoneButtonKey"),
          onPressed: () => launch("tel://${widget._business.profile.phone}"),
          child: Text(
            _formatPhone(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: Theme.of(context).colorScheme.callToAction
            ),
          )
        )
      ],
    );
  }

  Widget _hours() {
    return Row(
      key: const Key("hoursKey"),
      children: <Widget>[
        Icon(Icons.access_time, color: Theme.of(context).colorScheme.onPrimary),
        SizedBox(width: 16.w),
        Text(
          _formatOpenHour(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        )
      ],
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
      _errorLaunchUrlSnackbar();
    }
  }

  void _errorLaunchUrlSnackbar() {
    Vibrate.error();

    SnackBar snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SnackbarText(text: "An error occurred. Unable to open ${widget._business.profile.website}.")
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.error
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _goToTransactionFinderScreen() {
    Navigator.of(context).pushNamed(Routes.transactionPicker, arguments: TransactionPickerArgs(business: widget._business, fromSettings: false));
  }
}