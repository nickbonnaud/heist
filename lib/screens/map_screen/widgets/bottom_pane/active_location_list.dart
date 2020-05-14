import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/business_screen/business_screen.dart';

class ActiveLocationList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveLocationBloc, ActiveLocationState>(
      builder: (context, state) {
        if (state is CurrentActiveLocations) {
          List<Business> _businesses = BlocProvider.of<NearbyBusinessesBloc>(context).businesses;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    context.platformIcons.location, 
                    size: SizeConfig.getWidth(10)
                  ),
                  SizedBox(width: SizeConfig.getWidth(1)),
                  BoldText(text: "Where you're currently at:", size: SizeConfig.getWidth(5), color: Colors.grey),
                ],
              ),
              SizedBox(height: SizeConfig.getHeight(1)),
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 16),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    for (ActiveLocation activeLocation in state.activeLocations) _buildLocationIcon(context: context, location: activeLocation, businesses: _businesses)
                  ],
                ),
              )
            ],
          );
        }
        return Container(height: 0, width: 0,);
      }
    );
  }

  Widget _buildLocationIcon({@required BuildContext context, @required ActiveLocation location, @required List<Business> businesses}) {
    Business business = _findBusiness(location: location, businesses: businesses);
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: GestureDetector(
        child: Material(
          shape: CircleBorder(),
          elevation: 5,
          child: CircleAvatar(
            backgroundImage: NetworkImage(business.photos.logo.smallUrl),
            radius: SizeConfig.getWidth(8),
          ),
        ),
        onTap: () {
          BlocProvider.of<ActiveLocationBloc>(context).add(RemoveActiveLocation(beaconIdentifier: business.location.beacon.identifier));
        }
      ),
    );
  }

  Business _findBusiness({@required ActiveLocation location, @required List<Business> businesses}) {
    return businesses.firstWhere((Business business) {
      return location.beaconIdentifier == business.location.beacon.identifier;
    });
  }
}