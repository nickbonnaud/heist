import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/global_widgets/edit_photo/bloc/edit_photo_bloc.dart';
import 'package:heist/global_widgets/edit_photo/edit_photo.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/profile_repository.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';

class ProfilePhotoScreen extends StatefulWidget {
  final AnimationController _controller;

  ProfilePhotoScreen({@required AnimationController controller})
    : assert(controller != null),
      _controller = controller;

  @override
  State<ProfilePhotoScreen> createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  final ProfileRepository _profileRepository = ProfileRepository();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, bottom: 16, right: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: SizeConfig.getHeight(15)),
              BoldText.veryBold(
                text: "Next lets add a Profile Photo.", 
                size: SizeConfig.getWidth(6),
                color: Colors.black
              ),
              SizedBox(height: SizeConfig.getHeight(10)),
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
              SizedBox(height: SizeConfig.getHeight(8)),
              BoldText(
                text: "Your photo is used for your account security.", 
                size: SizeConfig.getWidth(4), 
                color: Colors.grey.shade600
              ),
              SizedBox(height: SizeConfig.getHeight(1)),
              BoldText(
                text: "Please use a photo from your shoulders up.", 
                size: SizeConfig.getWidth(4), 
                color: Colors.grey.shade600
              ),
              SizedBox(height: SizeConfig.getHeight(1)),
              BoldText(
                text: "This allows servers and cashiers to easily identify you.", 
                size: SizeConfig.getWidth(4), 
                color: Colors.grey.shade600
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    return RaisedButton(
                      color: Colors.green,
                      disabledColor: Colors.green.shade100,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: _isNextButtonEnabled(state.customer) ? () => _nextButtonPressed(context) : null,
                      child: BoldText(text: 'Next', size: SizeConfig.getWidth(6), color: Colors.white)
                    );
                  }
                )
              )
            ],
          )
        ],
      ), 
    );
  }

  @override
  void dispose() {
    widget._controller.removeStatusListener(_animationListener);
    super.dispose();
  }

  bool _isNextButtonEnabled(Customer customer) {
    String photoName = customer?.profile?.photos?.name;
    return photoName != null;
  }

  void _nextButtonPressed(BuildContext context) {
    widget._controller.addStatusListener(_animationListener);
    widget._controller.forward();
  }

  void _animationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      BlocProvider.of<ProfileSetupScreenBloc>(context).add(SectionCompleted(section: Section.photo));
    }
  }
}