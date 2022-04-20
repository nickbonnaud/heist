
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/global_widgets/cached_avatar.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/resources/test_helpers/mock_image_picker.dart';
import 'package:heist/test_blocs/is_testing_cubit.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/edit_photo_bloc.dart';
import 'widgets/fade_in_file.dart';

class EditPhoto extends StatelessWidget {
  final PhotoPickerRepository _photoPicker;
  final bool _autoDismiss;
  final Profile _profile;

  const EditPhoto({required PhotoPickerRepository photoPicker, required Profile profile, bool autoDismiss = false, Key? key})
    : _photoPicker = photoPicker,
      _autoDismiss = autoDismiss,
      _profile = profile,
      super(key: key);

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
            children: [
              _createAvatar(state: state),
              Positioned(
                bottom: 0.0,
                right: -10.0,
                child: RawMaterialButton(
                  key: const Key("addPhotoButtonKey"),
                  onPressed: () => _editPhoto(context: context, state: state),
                  child: state is Submitting 
                    ? CircularProgressIndicator(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      )
                    : Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onCallToAction,
                      ),
                  shape: const CircleBorder(),
                  elevation: 5.0,
                  fillColor: Theme.of(context).colorScheme.callToAction,
                  padding: EdgeInsets.all(15.sp),
                )
              )
            ],
          );
        }
      ),
    );
  }

  Widget _createAvatar({required EditPhotoState state}) {
    if (state is Submitting || state is SubmitSuccess) {
      XFile? photo = state is Submitting 
        ? state.photo 
        : state is SubmitSuccess 
          ? state.photo 
          : null;
      
      return FadeInFile(imageFile: photo!);
    } else if (_profile.photos.largeUrl.isEmpty) {
      return CircleAvatar(
        child: Image.asset('assets/profile_customer.png'),
        radius: 100.sp,
        backgroundColor: Colors.transparent,
      );
    } else {
      return CachedAvatar(
        url: _profile.photos.largeUrl,
        radius: 100.sp,
      );
    }
  }

  void _editPhoto({required BuildContext context, required EditPhotoState state}) async {
    if (state is !Submitting) {
      if (context.read<IsTestingCubit>().state) {
        XFile file = await MockImagePicker().init();
        BlocProvider.of<EditPhotoBloc>(context).add(ChangePhoto(profileIdentifier: _profile.identifier, photo: file));
        return;
      }

      final bool permissionGranted = await _requestPermission();
      if (permissionGranted) {
        XFile? photo = await _photoPicker.pickPhoto();
        if (photo != null) {
          BlocProvider.of<EditPhotoBloc>(context).add(ChangePhoto(profileIdentifier: _profile.identifier, photo: photo));
        }
      } else {
        _openAppSettings(context: context);
      }
    }
  }

  Future<bool> _requestPermission() async {
    final PermissionStatus status = await Permission.photos.request();
    return ([PermissionStatus.granted, PermissionStatus.limited].contains(status));
  }

  void _openAppSettings({required BuildContext context}) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: PlatformText("Please grant access to Camera"),
        content: Column(
          children: [
            SizedBox(height: 10.h),
            PlatformText("${Constants.appName} requires a Profile Photo to protect your security."),
            SizedBox(height: 15.h),
            PlatformText("* May restart app")
          ],
        ),
        actions: [
          PlatformDialogAction(
            child: PlatformText('Cancel'),
            onPressed: () => Navigator.pop(context)
          ),

          PlatformDialogAction(
            key: const Key("enablePermissionButtonKey"),
            child: PlatformText('Enable'),
            onPressed: () {
              openAppSettings();
              return Navigator.pop(context);
            }
          )
        ],
      )
    );
  }
  
  void _showSnackbar(BuildContext context, String message, EditPhotoState state) async {
    final bool isSuccess = state is SubmitSuccess;
    isSuccess ? Vibrate.success() : Vibrate.error();

    final SnackBar snackBar = SnackBar(
      key: const Key("editPhotoSnackbarKey"),
      duration: const Duration(seconds: 1),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SnackbarText(text: message)
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