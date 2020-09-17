import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';

class NoLocationsCard extends StatelessWidget {

  final String textBody =
  "Looks like you're exploring alien territory!\n\n"
  "${Constants.appName} is not currently available here.";
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1.0,
            blurRadius: 5,
            offset: Offset(0, -5)
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: SizeConfig.getHeight(2)),
              VeryBoldText2(text: 'Destination Unknown', context: context),
              SizedBox(height: SizeConfig.getHeight(6)),
              PlatformText(textBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimarySubdued,
                  fontSize: SizeConfig.getWidth(6),
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(width: SizeConfig.getWidth(20)),
              Expanded(
                child: BlocBuilder<GeoLocationBloc, GeoLocationState>(
                  builder: (context, state) {
                    return RaisedButton(
                      onPressed: state is Loading
                        ? null
                        : () => BlocProvider.of<GeoLocationBloc>(context).add(FetchLocation(accuracy: Accuracy.MEDIUM)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: state is Loading 
                        ? BoldText3(text: 'Fetching', context: context, color: Theme.of(context).colorScheme.onSecondary)
                        : BoldText3(text: 'Fetch Location', context: context, color: Theme.of(context).colorScheme.onSecondary),
                    );
                  }
                )
              ),
              SizedBox(width: SizeConfig.getWidth(20))
            ],
          )
        ],
      )
    );
  }
}