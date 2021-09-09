import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/email_screen/bloc/email_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailForm extends StatefulWidget {
  final Customer _customer;

  EmailForm({required Customer customer})
    : _customer = customer;

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final FocusNode _emailFocusNode = FocusNode();
  late TextEditingController _emailController;

  late EmailFormBloc _emailFormBloc;
  
  @override
  void initState() {
    super.initState();
    _emailFormBloc = BlocProvider.of<EmailFormBloc>(context);
    _emailController = TextEditingController(text: widget._customer.email);
    _emailController.addListener(_onEmailChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<EmailFormBloc, EmailFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSnackbar(isSuccess: true);
        } else if (state.errorMessage.isNotEmpty) {
          _showSnackbar(isSuccess: false, error: state.errorMessage);
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
                      ScreenTitle(title: 'Edit Email'),
                      _email(),
                      SizedBox(height: 60.h),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  children: [
                    Expanded(
                      child: _cancelButton()
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: _submitButton()
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Widget _email() {
    return BlocBuilder<EmailFormBloc, EmailFormState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("emailFieldKey"),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 25.sp
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28.sp
          ),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: _emailFocusNode,
          validator: (_) => !state.isEmailValid ? 'Invalid Email' : null,
        );
      }
    );
  }

  Widget _cancelButton() {
    return BlocBuilder<EmailFormBloc, EmailFormState>(
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
    );
  }

  Widget _submitButton() {
    return BlocBuilder<EmailFormBloc, EmailFormState>(
      builder: (context, state) {
        return ElevatedButton(
          key: Key("submitButtonKey"),
          onPressed: _isSaveButtonEnabled(state: state) ? () => _saveButtonPressed(state: state) : null,
          child: _buttonChild(state: state),
        );
      }
    );
  }

  Widget _buttonChild({required EmailFormState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: 25.sp, width: 25.sp, child: CircularProgressIndicator());
    } else {
      return ButtonText(text: 'Save');
    }
  }

  void _showSnackbar({required bool isSuccess, String? error}) async {
    isSuccess ? Vibrate.success() : Vibrate.error();

    final String text = isSuccess
      ? 'Email Updated!'
      : error!;

    final SnackBar snackBar = SnackBar(
      key: Key("emailFormSnackbarKey"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SnackbarText(text: text)
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
          Navigator.of(context).pop()
        } else {
          BlocProvider.of<EmailFormBloc>(context).add(Reset())
        }
      }
    );
  }

  void _cancelButtonPressed() {
    Navigator.pop(context);
  }

  bool _isSaveButtonEnabled({required EmailFormState state}) {
    return state.isEmailValid && _emailChanged() && _emailController.text.isNotEmpty && !state.isSubmitting;
  }

  bool _emailChanged() {
    return widget._customer.email != _emailController.text;
  }

  void _onEmailChanged() {
    _emailFormBloc.add(EmailChanged(email: _emailController.text));
  }
  
  void _saveButtonPressed({required EmailFormState state}) {
    if (_isSaveButtonEnabled(state: state)) {
      _emailFormBloc.add(Submitted(identifier: widget._customer.identifier, email: _emailController.text));
    }
  }

  KeyboardActionsConfig _buildKeyboard() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardActionsItem(
          focusNode: _emailFocusNode,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: ActionText()
                ),
              );
            }
          ]
        ),
      ]
    );
  }
}