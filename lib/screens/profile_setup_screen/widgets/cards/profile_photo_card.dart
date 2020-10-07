import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/global_widgets/edit_photo/bloc/edit_photo_bloc.dart';
import 'package:heist/global_widgets/edit_photo/edit_photo.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

class ProfilePhotoCard extends StatelessWidget {
  final ProfileRepository _profileRepository = ProfileRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, bottom: 16, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: SizeConfig.getHeight(1)),
                  VeryBoldText4(
                    text: "Next add a Profile Photo.", 
                    context: context
                  ),
                  BlocProvider<EditPhotoBloc>(
                    create: (BuildContext context) => EditPhotoBloc(
                      profileRepository: _profileRepository,
                      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)
                    ),
                    child: EditPhoto(
                      photoPicker: PhotoPickerRepository(),
                      customer: BlocProvider.of<AuthenticationBloc>(context).customer.profile != null
                        ? BlocProvider.of<AuthenticationBloc>(context).customer : null,
                      autoDismiss: false,
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        PlatformText(
                          "Your photo is used for your account security.",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimarySubdued,
                            fontSize: SizeConfig.getWidth(5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: SizeConfig.getHeight(2)),
                        PlatformText(
                          "Please use a photo from your shoulders up.",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimarySubdued,
                            fontSize: SizeConfig.getWidth(5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: SizeConfig.getHeight(2)),
                        PlatformText(
                          "This allows servers and cashiers to easily identify you.",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimarySubdued,
                            fontSize: SizeConfig.getWidth(5),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.getHeight(10)),
                ],
              )
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: _isNextButtonEnabled(state.customer) ? () => _nextButtonPressed(context: context) : null,
                        child: BoldText3(text: 'Next', context: context, color: Theme.of(context).colorScheme.onSecondary)
                      );
                    }
                  )
                )
              ],
            )
          ],
        ), 
      ),
    );
  }
  
  bool _isNextButtonEnabled(Customer customer) {
    String photoName = customer?.profile?.photos?.name;
    return photoName != null;
  }

  void _nextButtonPressed({@required BuildContext context}) {
    BlocProvider.of<ProfileSetupScreenBloc>(context).add(SectionCompleted(section: Section.photo));
  }
}