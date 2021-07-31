import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/email_screen/bloc/email_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

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
          _showSnackbar(context: context, isSuccess: true);
        } else if (state.errorMessage.isNotEmpty) {
          _showSnackbar(context: context, isSuccess: false, error: state.errorMessage);
        }
      },
      child: Form(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: KeyboardActions(
                  config: _buildKeyboard(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      VeryBoldText1(text: 'Edit Email', context: context),
                      _email(),
                      SizedBox(height: SizeConfig.getHeight(10)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _cancelButton()
                    ),
                    SizedBox(width: 20.0),
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
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.getWidth(6)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.getWidth(7)
          ),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: _emailFocusNode,
          validator: (_) => !state.isEmailValid ? 'Invalid email' : null,
        );
      }
    );
  }

  Widget _cancelButton() {
    return BlocBuilder<EmailFormBloc, EmailFormState>(
      builder: (context, state) {
        return OutlinedButton(
          onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(context),
          child: BoldText3(text: 'Cancel', context: context, color: state.isSubmitting
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
          onPressed: _isSaveButtonEnabled(state) ? () => _saveButtonPressed(state) : null,
          child: _buttonChild(state),
        );
      }
    );
  }

  void _showSnackbar({required BuildContext context, required bool isSuccess, String? error}) async {
    isSuccess ? Vibrate.success() : Vibrate.error();

    final String text = isSuccess
      ? 'Email Updated!'
      : error!;

    final SnackBar snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: BoldText3(text: text, context: context, color: Theme.of(context).colorScheme.onSecondary)
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

  void _cancelButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }

  bool _isSaveButtonEnabled(EmailFormState state) {
    return state.isEmailValid && _emailChanged() && _emailController.text.isNotEmpty && !state.isSubmitting;
  }

  bool _emailChanged() {
    return widget._customer.email != _emailController.text;
  }

  void _onEmailChanged() {
    _emailFormBloc.add(EmailChanged(email: _emailController.text));
  }
  
  void _saveButtonPressed(EmailFormState state) {
    if (_isSaveButtonEnabled(state)) {
      _emailFormBloc.add(Submitted(identifier: widget._customer.identifier, email: _emailController.text));
    }
  }

  Widget _buttonChild(EmailFormState state) {
    if (state.isSubmitting) {
      return SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator());
    } else {
      return BoldText3(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
  }

  KeyboardActionsConfig _buildKeyboard(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardActionsItem(
          focusNode: _emailFocusNode,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).colorScheme.primary),
                ),
              );
            }
          ]
        ),
      ]
    );
  }
}