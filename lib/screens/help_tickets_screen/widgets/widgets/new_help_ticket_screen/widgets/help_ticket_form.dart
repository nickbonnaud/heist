import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:heist/themes/global_colors.dart';

import '../bloc/help_ticket_form_bloc.dart';

class HelpTicketForm extends StatefulWidget {

  State<HelpTicketForm> createState() => _HelpTicketFormState();
}

class _HelpTicketFormState extends State<HelpTicketForm> {
  final TextEditingController _subjectController = TextEditingController();
  final FocusNode _subjectFocus = FocusNode();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocus = FocusNode();
  late HelpTicketFormBloc _helpTicketFormBloc;

  bool get isPopulated => _subjectController.text.isNotEmpty && _messageController.text.isNotEmpty;
  
  @override
  void initState() {
    super.initState();
    _helpTicketFormBloc = BlocProvider.of<HelpTicketFormBloc>(context);

    _subjectController.addListener(_onSubjectChanged);
    _messageController.addListener(_onMessageChanged);
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
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: KeyboardActions(
                  config: _buildKeyboard(),
                  child: Column(
                    mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                    children: [
                      VeryBoldText2(text: 'Create Help Ticket', context: context),
                      _subjectField(),
                      _messageField()
                    ],
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _cancelButton()
                    ),
                    SizedBox(width: 20.0),
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
    _subjectController.dispose();
    _messageController.dispose();

    _subjectFocus.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  Widget _subjectField() {
    return BlocBuilder<HelpTicketFormBloc, HelpTicketFormState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("subjectFieldKey"),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            labelText: 'Subject',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.getWidth(5)
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.getWidth(5)
          ),
          controller: _subjectController,
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
          key: Key("messageFieldKey"),
          cursorColor: Colors.black,
          decoration: InputDecoration(
            labelText: "Message",
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.getWidth(5)
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: SizeConfig.getWidth(5)
          ),
          controller: _messageController,
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
          key: Key("cancelButtonKey"),
          onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(),
          child: BoldText3(text: 'Cancel', context: context, color: state.isSubmitting 
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
          key: Key("submitButtonKey"),
          onPressed: _isSubmitButtonEnabled(state: state)
            ? () => _submitButtonPressed(state: state)
            : null, 
          child: _buttonChild(state: state)
        );
      },
    );
  }

  void _onSubjectChanged() {
    _helpTicketFormBloc.add(SubjectChanged(subject: _subjectController.text));
  }

  void _onMessageChanged() {
    _helpTicketFormBloc.add(MessageChanged(message: _messageController.text));
  }

  void _cancelButtonPressed() {
    Navigator.of(context).pop();
  }

  bool _isSubmitButtonEnabled({required HelpTicketFormState state}) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _submitButtonPressed({required HelpTicketFormState state}) {
    if (_isSubmitButtonEnabled(state: state)) {
      _helpTicketFormBloc.add(Submitted(
        subject: _subjectController.text,
        message: _messageController.text
      ));
    }
  }
  
  void _showSnackbar({required String text, required HelpTicketFormState state}) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: Key("newHelpTicketSnackbarKey"),
      content: Row(
        children: [
          Expanded(
            child: BoldText3(text: text, context: context, color: Theme.of(context).colorScheme.onSecondary)
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

  Widget _buttonChild({required HelpTicketFormState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator());
    }
    return BoldText3(text: "Submit", context: context, color: Theme.of(context).colorScheme.onSecondary);
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
    return GestureDetector(
      onTap: () => node.unfocus(),
      child: Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: BoldText5(text: 'Done', context: context, color: Theme.of(context).primaryColor),
      ),
    );
  }
}