import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/screens/home_screen/blocs/business_screen_visible_cubit.dart';

import 'widgets/fetch_businesses_fail_screen/fetch_businesses_fail_screen.dart';
import 'widgets/nearby_businesses_map/nearby_businesses_map.dart';
import 'widgets/no_nearby_locations/no_nearby_locations.dart';
import 'widgets/peek_sheet/peek_sheet.dart';

class HomeScreenBody extends StatelessWidget {

  const HomeScreenBody({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NearbyBusinessesBloc, NearbyBusinessesState>(
      builder: (context, state) {
        if (state is NearbyBusinessLoaded) {
          
          if (state.businesses.isEmpty) {
            return const NoNearbyLocations();
          }
          return Stack(
            children: [
              const NearbyBusinessesMap(),
              const PeekSheet(),
              _dimmer(context: context)
            ],
          );
        } else if (state is NearbyUninitialized || state is LoadingNearbyBusinesses) {
          return _fetchingLocation();
        }
        return const FetchBusinessesFailScreen();
      },
    );
  }

  Widget _fetchingLocation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        SizedBox(height: 40.h),
        Text(
          "Fetching Location...",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 30.sp
          ),
        ),
      ],
    );
  }

  Widget _dimmer({required BuildContext context}) {
    return BlocBuilder<BusinessScreenVisibleCubit, bool>(
      builder: (context, isVisible) {
        return AnimatedOpacity(
          key: const Key("dimmerKey"),
          opacity: isVisible
            ? 0.5
            : 0.0,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          child: IgnorePointer(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
            ),
          ),
        );
      }
    );
  }
}