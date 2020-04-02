import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/profile_screen/widgets/edit_photo/bloc/edit_photo_bloc.dart';
import 'package:vibrate/vibrate.dart';

class EditPhoto extends StatelessWidget {
  final PhotoPickerRepository _photoPicker;

  EditPhoto({@required PhotoPickerRepository photoPicker})
    : assert(photoPicker != null),
      _photoPicker = photoPicker;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditPhotoBloc, EditPhotoState>(
      listener: (context, state) {
        if (state is SubmitFailed) {
          _showErrorSnackbar(context);
        } else if (state is SubmitSuccess) {
          _showSuccessSnackbar(context);
        }
      },
      child: BlocBuilder<EditPhotoBloc, EditPhotoState>(
        builder: (context, state) {
          return Stack(
            children: <Widget>[
              _createAvatar(state),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: RawMaterialButton(
                  onPressed: () => _editPhoto(context, state),
                  child: state is Submitting 
                    ? CircularProgressIndicator()
                    : PlatformWidget(
                    ios: (_) => Icon(
                      IconData(
                        0xF2BF,
                        fontFamily: CupertinoIcons.iconFont,
                        fontPackage: CupertinoIcons.iconFontPackage
                      ),
                      color: Colors.white,
                    ),
                    android: (_) => Icon(
                      Icons.edit,
                      color: Colors.white
                    ),
                  ),
                  shape: CircleBorder(),
                  elevation: 5.0,
                  fillColor: Colors.green,
                  padding: EdgeInsets.all(SizeConfig.getWidth(3)),
                )
              )
            ],
          );
        }
      ),
    );
  }

  Widget _createAvatar(EditPhotoState state) {
    Customer customer = state is PhotoUnchanged ? state.customer : (state is SubmitFailed ? state.customer : null);
    if (customer != null) {
      return CircleAvatar(
        backgroundImage: NetworkImage(customer.profile.photos.largeUrl),
        radius: SizeConfig.getWidth(25),
      );
    } else if (state is Submitting || state is SubmitSuccess) {
      File photo = state is Submitting ? state.photo : state is SubmitSuccess ? state.photo : null;
      return CircleAvatar(
        backgroundImage: Image.file(photo).image,
        radius: SizeConfig.getWidth(25),
      );
    } else {
      return CircleAvatar(
        child: Image.asset('assets/profile_customer.png'),
        radius: SizeConfig.getWidth(25),
      );
    }
  }

  void _editPhoto(BuildContext context, EditPhotoState state) async {
    Customer customer = state is PhotoUnchanged ? state.customer : (state is SubmitFailed ? state.customer : null);
    if (customer != null)  {
      File photo = await _photoPicker.pickPhoto();
      BlocProvider.of<EditPhotoBloc>(context).add(ChangePhoto(customer: customer, photo: photo));
    }
  }

  void _showSuccessSnackbar(BuildContext context) async {
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.success);
    }

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: BoldText(text: "Photo updated!", size: SizeConfig.getWidth(6), color: Colors.white)
              ),
              PlatformWidget(
                android: (_) => Icon(Icons.check_circle_outline),
                ios: (_) => Icon(
                  IconData(
                    0xF3FE,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  ),
                  color: Colors.white,
                ),
              )
            ],
          ),
          backgroundColor: Colors.green,
        )
      ).closed.then((_) => Navigator.of(context).pop());
  }
  
  void _showErrorSnackbar(BuildContext context) async {
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(FeedbackType.error);

      Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: NormalText(text: "Failed to upload photo. Please try again.", size: SizeConfig.getWidth(6), color: Colors.white)
              ),
              PlatformWidget(
                android: (_) => Icon(Icons.error),
                ios: (_) => Icon(
                  IconData(
                    0xF35B,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  ),
                  color: Colors.white,
                ),
              )
            ],
          ),
          backgroundColor: Colors.red,
        )
      );
    }
  }
}