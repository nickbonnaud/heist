import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/help_ticket_form_bloc.dart';

class HelpTicketForm extends StatefulWidget {

  const HelpTicketForm({Key? key})
    : super(key: key);
  
  @override
  State<HelpTicketForm> createState() => _HelpTicketFormState();
}

class _HelpTicketFormState extends State<HelpTicketForm> {
  final FocusNode _subjectFocus = FocusNode();
  final FocusNode _messageFocus = FocusNode();

  late HelpTicketFormBloc _helpTicketFormBloc;
  
  @override
  void initState() {
    super.initState();
    _helpTicketFormBloc = BlocProvider.of<HelpTicketFormBloc>(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<HelpTicketFormBloc, HelpTicketFormState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          _showSnackbar(text: state.errorMessage, state: state);
        } else if (state.isSuccess) {
          _showSnackbar(text: "Help Ticket created!", state: state);
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const ScreenTitle(title: 'New Help Ticket'),
                      _subjectField(),
                      _messageField()
                    ],
                  ),
                )
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
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    _subjectFocus.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  Widget _subjectField() {
    return BlocBuilder<HelpTicketFormBloc, HelpTicketFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("subjectFieldKey"),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            labelText: 'Subject',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 25.sp
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28.sp
          ),
          onChanged: (subject) => _onSubjectChanged(subject: subject),
          focusNode: _subjectFocus,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) => !state.isSubjectValid
            ? 'A Subject is required!'
            : null 
        );
      }
    );
  }

  Widget _messageField() {
    return BlocBuilder<HelpTicketFormBloc, HelpTicketFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("messageFieldKey"),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            labelText: "Message",
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 25.sp
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 28.sp
          ),
          onChanged: (message) => _onMessageChanged(message: message),
          focusNode: _messageFocus,
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) => !state.isMessageValid
            ? 'Please include details about the issue.'
            : null,
        );
      }
    );
  }

  Widget _cancelButton() {
    return BlocBuilder<HelpTicketFormBloc, HelpTicketFormState>(
      builder: (context, state) {
        return OutlinedButton(
          key: const Key("cancelButtonKey"),
          onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(),
          child: ButtonText(text: 'Cancel', color: state.isSubmitting 
            ? Theme.of(context).colorScheme.callToActionDisabled
            : Theme.of(context).colorScheme.callToAction
          ),
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<HelpTicketFormBloc, HelpTicketFormState>(
      builder: (context, state) {
        return ElevatedButton(
          key: const Key("submitButtonKey"),
          onPressed: _isSubmitButtonEnabled(state: state)
            ? () => _submitButtonPressed(state: state)
            : null, 
          child: _buttonChild(state: state)
        );
      },
    );
  }

  Widget _buttonChild({required HelpTicketFormState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: 25.sp, width: 25.sp, child: const CircularProgressIndicator());
    }
    return const ButtonText(text: "Submit");
  }

  void _onSubjectChanged({required String subject}) {
    _helpTicketFormBloc.add(SubjectChanged(subject: subject));
  }

  void _onMessageChanged({required String message}) {
    _helpTicketFormBloc.add(MessageChanged(message: message));
  }

  void _cancelButtonPressed() {
    Navigator.of(context).pop();
  }

  bool _isSubmitButtonEnabled({required HelpTicketFormState state}) {
    return state.isFormValid && !state.isSubmitting;
  }

  void _submitButtonPressed({required HelpTicketFormState state}) {
    if (_isSubmitButtonEnabled(state: state)) {
      _helpTicketFormBloc.add(Submitted());
    }
  }
  
  void _showSnackbar({required String text, required HelpTicketFormState state}) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: const Key("newHelpTicketSnackbarKey"),
      content: Row(
        children: [
          Expanded(
            child: SnackbarText(text: text)
          )
        ],
      ),
      backgroundColor: state.isSuccess
        ? Theme.of(context).colorScheme.success
        : Theme.of(context).colorScheme.error
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) {
        if (state.isSuccess) {
          Navigator.of(context).pop();
        } else {
          BlocProvider.of<HelpTicketFormBloc>(context).add(Reset());
        }
      }
    );
  }
  
  KeyboardActionsConfig _buildKeyboard() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardActionsItem(
          focusNode: _subjectFocus,
          toolbarButtons: [
            (node) => _toolBarButton(node: node)
          ]
        ),
        KeyboardActionsItem(
          focusNode: _messageFocus,
          toolbarButtons: [
            (node) => _toolBarButton(node: node)
          ]
        )
      ]
    );
  }

  Widget _toolBarButton({required FocusNode node}) {
    return TextButton(
      onPressed: () => node.unfocus(),
      child: Padding(
        padding: EdgeInsets.only(right: 16.w),
        child: const ActionText()
      ),
    );
  }
}