import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/edit_photo/bloc/edit_photo_bloc.dart';
import 'package:heist/global_widgets/edit_photo/edit_photo.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import './widgets/title_text.dart';

class ProfilePhotoCard extends StatelessWidget {

  const ProfilePhotoCard({Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, bottom: 16.h, right: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10.h),
                  const TitleText(text: "Next add a Profile Photo."),
                  BlocProvider<EditPhotoBloc>(
                    create: (BuildContext context) => EditPhotoBloc(
                      photoRepository: RepositoryProvider.of<PhotoRepository>(context),
                      customerBloc: BlocProvider.of<CustomerBloc>(context),
                    ),
                    child: const EditPhoto(autoDismiss: false),
                  ),
                  Column(
                    children: [
                      Text(
                        "Your photo is used for your account security.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimarySubdued,
                          fontSize: 20.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Please use a photo from your shoulders up.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimarySubdued,
                          fontSize: 20.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "This allows servers and cashiers to easily identify you.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimarySubdued,
                          fontSize: 20.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 65.h),
                ],
              )
            ),
            Row(
              children: [
                SizedBox(width: .1.sw),
                Expanded(
                  child: BlocBuilder<CustomerBloc, CustomerState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        key: const Key("submitPhotoButtonKey"),
                        onPressed: _isNextButtonEnabled(customer: state.customer!) ? () => _nextButtonPressed(context: context) : null,
                        child: const ButtonText(text: 'Next')
                      );
                    }
                  )
                ),
                SizedBox(width: .1.sw)
              ],
            )
          ],
        ), 
      ),
    );
  }
  
  bool _isNextButtonEnabled({required Customer customer}) {
    return customer.profile.photos.name.isNotEmpty;
  }

  void _nextButtonPressed({required BuildContext context}) {
    BlocProvider.of<ProfileSetupScreenBloc>(context).add(const SectionCompleted(section: Section.photo));
  }
}