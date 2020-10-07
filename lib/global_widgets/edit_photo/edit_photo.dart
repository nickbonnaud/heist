import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/cached_avatar.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:vibrate/vibrate.dart';

import 'bloc/edit_photo_bloc.dart';
import 'widgets/fade_in_file.dart';

class EditPhoto extends StatelessWidget {
  final PhotoPickerRepository _photoPicker;
  final Customer _customer;
  final bool _autoDismiss;

  EditPhoto({@required PhotoPickerRepository photoPicker, Customer customer, bool autoDismiss})
    : assert(photoPicker != null),
      _photoPicker = photoPicker,
      _customer = customer,
      _autoDismiss = autoDismiss;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditPhotoBloc, EditPhotoState>(
      listener: (context, state) {
        if (state is SubmitSuccess) {
          _showSnackbar(context, "Photo updated!", state);
        } else if (state is SubmitFailed) {
          _showSnackbar(context, "Failed to upload photo. Please try again.", state);
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
                    ? CircularProgressIndicator(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    )
                    : Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onCallToAction,
                      ),
                  shape: CircleBorder(),
                  elevation: 5.0,
                  fillColor: Theme.of(context).colorScheme.callToAction,
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
   if (state is Submitting || state is SubmitSuccess) {
      File photo = state is Submitting ? state.photo : state is SubmitSuccess ? state.photo : null;
      return FadeInFile(imageFile: photo);
    } else if (_customer?.profile?.photos == null) {
      return CircleAvatar(
        child: Image.asset('assets/profile_customer.png'),
        radius: SizeConfig.getWidth(25),
        backgroundColor: Colors.transparent,
      );
    } else {
      return CachedAvatar(
        url: _customer.profile?.photos?.largeUrl, 
        radius: 25,
        showLoading: true,
      );
    }
  }

  void _editPhoto(BuildContext context, EditPhotoState state) async {
    if (state is !Submitting) {
      File photo = await _photoPicker.pickPhoto();
      BlocProvider.of<EditPhotoBloc>(context).add(ChangePhoto(customer: _customer, photo: photo));
    }
  }

  void _showSnackbar(BuildContext context, String message, EditPhotoState state) async {
    bool canVibrate = await Vibrate.canVibrate;
    bool isSuccess = state is SubmitSuccess;
    if (canVibrate) {
      Vibrate.feedback(isSuccess ? FeedbackType.success : FeedbackType.error);
    }

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: BoldText3(text: message, context: context, color: Theme.of(context).colorScheme.onSecondary)
              ),
            ],
          ),
          backgroundColor: isSuccess 
            ? Theme.of(context).colorScheme.success
            : Theme.of(context).colorScheme.error,
        )
      ).closed.then((_) => {
        if (isSuccess) {
          if (_autoDismiss) {
            Navigator.of(context).pop()
          }
        } else {
          BlocProvider.of<EditPhotoBloc>(context).add(ResetPhotoForm())
        }
      });
  }
}