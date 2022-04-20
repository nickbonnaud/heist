import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoLocationsCard extends StatelessWidget {

  const NoLocationsCard({Key? key})
    : super(key: key);
  
  static const String textBody =
  "Looks like you're exploring alien territory!\n\n"
  "${Constants.appName} is not currently available here.";
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 20.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1.0,
            blurRadius: 5,
            offset: Offset(0, -5.h)
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 18.h),
              Text(
                'Destination Unknown',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30.sp
                ),
              ),
              SizedBox(height: 40.h),
              Text(
                textBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimarySubdued,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(width: .1.sw),
              Expanded(
                child: BlocBuilder<GeoLocationBloc, GeoLocationState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is Loading
                        ? null
                        : () => BlocProvider.of<GeoLocationBloc>(context).add(const FetchLocation(accuracy: Accuracy.medium)),
                      child: state is Loading 
                        ? const ButtonText(text: 'Fetching')
                        : const ButtonText(text: 'Fetch Location'),
                    );
                  }
                )
              ),
              SizedBox(width: .1.sw),
            ],
          )
        ],
      )
    );
  }
}