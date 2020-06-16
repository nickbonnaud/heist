import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';

import 'show_business_button.dart';


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
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.getWidth(15)),
                child: Divider(thickness: 2),
              ),
              SizedBox(height: SizeConfig.getHeight(1)),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Icon(
                      Icons.pin_drop,
                      size: SizeConfig.getWidth(10)
                    ),
                  ),
                  SizedBox(width: SizeConfig.getWidth(1)),
                  BoldText(text: "Your Active Locations:", size: SizeConfig.getWidth(5), color: Colors.grey),
                ],
              ),
              SizedBox(height: SizeConfig.getHeight(1)),
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 16),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    for (ActiveLocation activeLocation in state.activeLocations) _createActiveLocationIcon(location: activeLocation, businesses: _businesses)
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.getHeight(2)),
            ],
          );
        }
        return BlocBuilder<NearbyBusinessesBloc, NearbyBusinessesState>(
          builder: (context, state) {
            if (state is NearbyBusinessLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: SizeConfig.getWidth(15)),
                    child: Divider(thickness: 2),
                  ),
                  SizedBox(height: SizeConfig.getHeight(1)),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Icon(
                          Icons.location_city, 
                          size: SizeConfig.getWidth(10)
                        ),
                      ),
                      SizedBox(width: SizeConfig.getWidth(1)),
                      Expanded(
                        child: BoldText(text: "No Active Locations, checkout some nearby businesses:", size: SizeConfig.getWidth(5), color: Colors.grey),
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.getHeight(1)),
                  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 16),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        for (Business business in state.businesses) _buildIcon(business: business)
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.getHeight(2)),
                ],
              );
            }
            return Container();
          }
        );
      }
    );
  }

  Widget _createActiveLocationIcon({@required ActiveLocation location, @required List<Business> businesses}) {
    Business business = _findBusiness(location: location, businesses: businesses);
    return _buildIcon(business: business);
  }
  
  Widget _buildIcon({@required Business business}) {
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: ShowBusinessButton(business: business)
    );
  }

  Business _findBusiness({@required ActiveLocation location, @required List<Business> businesses}) {
    return businesses.firstWhere((Business business) {
      return location.beaconIdentifier == business.location.beacon.identifier;
    });
  }
}