import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/global_widgets/edit_photo/bloc/edit_photo_bloc.dart';
import 'package:heist/global_widgets/edit_photo/edit_photo.dart';
import 'package:heist/models/customer/profile.dart';
import 'package:heist/repositories/photo_repository.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/profile_screen/bloc/profile_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';


class ProfileForm extends StatefulWidget {

  const ProfileForm({Key? key})
    : super(key: key);

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();

  late ProfileFormBloc _profileFormBloc;

  @override
  void initState() {
    super.initState();
    _profileFormBloc = BlocProvider.of<ProfileFormBloc>(context);
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
                      const ScreenTitle(title: 'Edit Profile'),
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
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    super.dispose();
  }

  Widget _photo() {
    return Center(
      child: BlocProvider<EditPhotoBloc>(
        create: (BuildContext context) => EditPhotoBloc(
          photoRepository: RepositoryProvider.of<PhotoRepository>(context),
          customerBloc:BlocProvider.of<CustomerBloc>(context)
        ),
        child: const EditPhoto(),
      )
    );
  }

  Widget _firstNameField() {
    return BlocBuilder<ProfileFormBloc, ProfileFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("firstNameFieldKey"),
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
          onChanged: (firstName) => _onFirstNameChanged(firstName: firstName),
          initialValue: BlocProvider.of<CustomerBloc>(context).customer!.profile.firstName,
          focusNode: _firstNameFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) => !state.isFirstNameValid && state.firstName.isNotEmpty 
            ? 'Invalid First Name'
            : null,
        );
      }
    );
  }

  Widget _lastNameField() {
    return BlocBuilder<ProfileFormBloc, ProfileFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("lastNameFieldKey"),
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
          onChanged: (lastName) => _onLastNameChanged(lastName: lastName),
          initialValue: BlocProvider.of<CustomerBloc>(context).customer!.profile.lastName,
          focusNode: _lastNameFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) => !state.isLastNameValid && state.lastName.isNotEmpty
            ? 'Invalid Last Name' 
            : null,
        );
      }
    );
  }

  Widget _cancelButton() {
    return Expanded(
      child: BlocBuilder<ProfileFormBloc, ProfileFormState>(
        builder: (context, state) {
          return OutlinedButton(
            key: const Key("cancelButtonKey"),
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
            key: const Key("submitButtonKey"),
            onPressed: _isSaveButtonEnabled(state: state) ? () => _saveButtonPressed(state: state) : null,
            child: _buttonChild(state: state),
          );
        }
      ) 
    );
  }
  
  Widget _buttonChild({required ProfileFormState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: 25.sp, width: 25.sp, child: const CircularProgressIndicator());
    } else {
      return const ButtonText(text: 'Save');
    }
  }
  
  void _onFirstNameChanged({required String firstName}) {
    _profileFormBloc.add(FirstNameChanged(firstName: firstName));
  }

  void _onLastNameChanged({required String lastName}) {
    _profileFormBloc.add(LastNameChanged(lastName: lastName));
  }

  bool _isSaveButtonEnabled({required ProfileFormState state}) {
    return state.isFormValid && !state.isSubmitting && _formFieldsChanged(state: state);
  }

  bool _formFieldsChanged({required ProfileFormState state}) {
    Profile profile = BlocProvider.of<CustomerBloc>(context).customer!.profile;
    return (profile.firstName != state.firstName)
      || (profile.lastName != state.lastName);
  }
  
  void _saveButtonPressed({required ProfileFormState state}) {
    if (_isSaveButtonEnabled(state: state)) {
      _profileFormBloc.add(Submitted());
    }
  }

  void _cancelButtonPressed() {
    Navigator.pop(context);
  }

  void _showSnackbar({required String message, required ProfileFormState state}) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: const Key("profileFormSnackbarKey"),
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
                  child: const ActionText()
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
                  child: const ActionText()
                )
              );
            }
          ]
        ),
      ]
    );
  }
}