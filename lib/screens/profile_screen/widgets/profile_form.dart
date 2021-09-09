import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/edit_photo/bloc/edit_photo_bloc.dart';
import 'package:heist/global_widgets/edit_photo/edit_photo.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/repositories/photo_picker_repository.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/profile_screen/bloc/profile_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ProfileForm extends StatefulWidget {
  final Profile _profile;
  final PhotoRepository _photoRepository;
  final PhotoPickerRepository _photoPickerRepository;
  final CustomerBloc _customerBloc;

  ProfileForm({
    required Profile profile,
    required PhotoRepository photoRepository,
    required PhotoPickerRepository photoPickerRepository,
    required CustomerBloc customerBloc
  })
    : _profile = profile,
      _photoRepository = photoRepository,
      _photoPickerRepository = photoPickerRepository,
      _customerBloc = customerBloc;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  late TextEditingController _firstNameController;
  final FocusNode _firstNameFocus = FocusNode();
  late TextEditingController _lastNameController;
  final FocusNode _lastNameFocus = FocusNode();

  bool get isPopulated => _firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty;

  late ProfileFormBloc _profileFormBloc;

  @override
  void initState() {
    super.initState();
    _profileFormBloc = BlocProvider.of<ProfileFormBloc>(context);
    _firstNameController = TextEditingController(text: widget._profile.firstName);
    _lastNameController = TextEditingController(text: widget._profile.lastName);
    _firstNameController.addListener(_onFirstNameChanged);
    _lastNameController.addListener(_onLastNameChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileFormBloc, ProfileFormState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          _showSnackbar(message: state.errorMessage, state: state);
        } else if (state.isSuccess) {
          _showSnackbar(message: 'Profile Updated!', state: state);
        }
      },
      child: Form(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: KeyboardActions(
                  config: _buildKeyboard(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ScreenTitle(title: 'Edit Profile'),
                      SizedBox(height: 50.h),
                      _photo(),
                      SizedBox(height: 50.h),
                      _firstNameField(),
                      _lastNameField(),
                      SizedBox(height: 80.h),
                    ],
                  ),
                ) ,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  children: [
                    _cancelButton(),
                    SizedBox(width: 20.w),
                    _submitButton()
                  ],
                ),
              ),
            ],
          )
        )
      )
    );
  }
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();

    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    super.dispose();
  }

  Widget _photo() {
    return Center(
      child: BlocProvider<EditPhotoBloc>(
        create: (BuildContext context) => EditPhotoBloc(photoRepository: widget._photoRepository, customerBloc: widget._customerBloc),
        child: EditPhoto(photoPicker: widget._photoPickerRepository, profile: widget._profile,),
      )
    );
  }

  Widget _firstNameField() {
    return BlocBuilder<ProfileFormBloc, ProfileFormState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("firstNameFieldKey"),
          decoration: InputDecoration(
            labelText: 'First Name',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 25.sp
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28.sp
          ),
          controller: _firstNameController,
          focusNode: _firstNameFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) => !state.isFirstNameValid ? 'Invalid First Name' : null,
        );
      }
    );
  }

  Widget _lastNameField() {
    return BlocBuilder<ProfileFormBloc, ProfileFormState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("lastNameFieldKey"),
          decoration: InputDecoration(
            labelText: 'Last Name',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 25.sp
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28.sp
          ),
          controller: _lastNameController,
          focusNode: _lastNameFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) => !state.isLastNameValid ? 'Invalid Last Name' : null,
        );
      }
    );
  }

  Widget _cancelButton() {
    return Expanded(
      child: BlocBuilder<ProfileFormBloc, ProfileFormState>(
        builder: (context, state) {
          return OutlinedButton(
            key: Key("cancelButtonKey"),
            onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(),
            child: ButtonText(text: 'Cancel', color: state.isSubmitting 
              ? Theme.of(context).colorScheme.callToActionDisabled
              : Theme.of(context).colorScheme.callToAction
            ),
          );
        }
      ),
    );
  }

  Widget _submitButton() {
    return Expanded(
      child: BlocBuilder<ProfileFormBloc, ProfileFormState>(
        builder: (context, state) {
          return ElevatedButton(
            key: Key("submitButtonKey"),
            onPressed: _isSaveButtonEnabled(state: state) ? () => _saveButtonPressed(state: state) : null,
            child: _buttonChild(state: state),
          );
        }
      ) 
    );
  }
  
  Widget _buttonChild({required ProfileFormState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: 25.sp, width: 25.sp, child: CircularProgressIndicator());
    } else {
      return ButtonText(text: 'Save');
    }
  }
  
  void _onFirstNameChanged() {
    _profileFormBloc.add(FirstNameChanged(firstName: _firstNameController.text));
  }

  void _onLastNameChanged() {
    _profileFormBloc.add(LastNameChanged(lastName: _lastNameController.text));
  }

  bool _isSaveButtonEnabled({required ProfileFormState state}) {
    return state.isFormValid && _formFieldsChanged() && isPopulated && !state.isSubmitting;
  }

  bool _formFieldsChanged() {
    return (widget._profile.firstName != _firstNameController.text)
      || (widget._profile.lastName != _lastNameController.text);
  }
  
  void _saveButtonPressed({required ProfileFormState state}) {
    if (_isSaveButtonEnabled(state: state)) {
      _profileFormBloc.add(Submitted(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        profileIdentifier: widget._profile.identifier));
    }
  }

  void _cancelButtonPressed() {
    Navigator.pop(context);
  }

  void _showSnackbar({required String message, required ProfileFormState state}) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: Key("profileFormSnackbarKey"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SnackbarText(text: message)
          ),
        ],
      ),
      backgroundColor: state.isSuccess
        ? Theme.of(context).colorScheme.success
        : Theme.of(context).colorScheme.error,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) => {
        if (state.isSuccess) {
          Navigator.of(context).pop()
        } else {
          BlocProvider.of<ProfileFormBloc>(context).add(Reset())
        }
      }
    );
  }

  KeyboardActionsConfig _buildKeyboard() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardActionsItem(
          focusNode: _firstNameFocus,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(), 
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: ActionText()
                )
              );
            }
          ]
        ),
        KeyboardActionsItem(
          focusNode: _lastNameFocus,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(), 
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: ActionText()
                )
              );
            }
          ]
        ),
      ]
    );
  }
}