import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/edit_photo/bloc/edit_photo_bloc.dart';
import 'package:heist/global_widgets/edit_photo/edit_photo.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

class ProfilePhotoCard extends StatelessWidget {
  final PhotoRepository _photoRepository;
  final PhotoPickerRepository _photoPickerRepository;
  final CustomerBloc _customerBloc;
  final Profile _profile;


  ProfilePhotoCard({
    required PhotoRepository photoRepository,
    required PhotoPickerRepository photoPickerRepository,
    required CustomerBloc customerBloc,
    required Profile profile
  })
    : _photoRepository = photoRepository,
      _photoPickerRepository = photoPickerRepository,
      _customerBloc = customerBloc,
      _profile = profile;

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
                      photoRepository: _photoRepository,
                      customerBloc: _customerBloc,
                    ),
                    child: EditPhoto(
                      photoPicker: _photoPickerRepository,
                      profile: _profile,
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
                  child: BlocBuilder<CustomerBloc, CustomerState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        key: Key("submitPhotoButtonKey"),
                        onPressed: _isNextButtonEnabled(customer: state.customer!) ? () => _nextButtonPressed(context: context) : null,
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
  
  bool _isNextButtonEnabled({required Customer customer}) {
    return customer.profile.photos.name.isNotEmpty;
  }

  void _nextButtonPressed({required BuildContext context}) {
    BlocProvider.of<ProfileSetupScreenBloc>(context).add(SectionCompleted(section: Section.photo));
  }
}