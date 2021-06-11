import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/cached_avatar.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:image_picker/image_picker.dart';

import 'bloc/edit_photo_bloc.dart';
import 'widgets/fade_in_file.dart';

class EditPhoto extends StatelessWidget {
  final PhotoPickerRepository _photoPicker;
  final bool _autoDismiss;
  final Profile _profile;

  EditPhoto({required PhotoPickerRepository photoPicker, required Profile profile, bool autoDismiss = false})
    : _photoPicker = photoPicker,
      _autoDismiss = autoDismiss,
      _profile = profile;

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
      PickedFile? photo = state is Submitting 
        ? state.photo 
        : state is SubmitSuccess 
          ? state.photo 
          : null;
      
      return FadeInFile(imageFile: photo!);
    } else if (_profile.photos.largeUrl.isEmpty) {
      return CircleAvatar(
        child: Image.asset('assets/profile_customer.png'),
        radius: SizeConfig.getWidth(25),
        backgroundColor: Colors.transparent,
      );
    } else {
      return CachedAvatar(
        url: _profile.photos.largeUrl, 
        radius: 25,
        showLoading: true,
      );
    }
  }

  void _editPhoto(BuildContext context, EditPhotoState state) async {
    if (state is !Submitting) {
      PickedFile? photo = await _photoPicker.pickPhoto();
      if (photo != null) {
        BlocProvider.of<EditPhotoBloc>(context).add(ChangePhoto(profile: _profile, photo: photo));
      }
    }
  }

  void _showSnackbar(BuildContext context, String message, EditPhotoState state) async {
    final bool isSuccess = state is SubmitSuccess;
    isSuccess ? Vibrate.success() : Vibrate.error();

    final SnackBar snackBar = SnackBar(
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
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) => {
        if (isSuccess) {
          if (_autoDismiss) {
            Navigator.of(context).pop()
          }
        } else {
          BlocProvider.of<EditPhotoBloc>(context).add(ResetPhotoForm())
        }
      }
    );
  }
}