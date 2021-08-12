import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/message_input_bloc.dart';

class MessageInput extends StatefulWidget {
  final String _ticketIdentifier;
  final ScrollController _scrollController;

  MessageInput({required String ticketIdentifier, required ScrollController scrollController})
    : _ticketIdentifier = ticketIdentifier,
      _scrollController = scrollController;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final FocusNode _inputFocusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  
  late MessageInputBloc _messageInputBloc;

  @override
  void initState() {
    super.initState();
    _messageInputBloc = BlocProvider.of<MessageInputBloc>(context);

    _controller.addListener(_onInputChanged);
    widget._scrollController.addListener(_onScrollChange);

    _inputFocusNode.requestFocus();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageInputBloc, MessageInputState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          _showSnackbar(error: state.errorMessage);
        }
      },
      child: Container(
        child: Row(
          children: [
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 8.0, top: 8.0),
                child: _textField()
              )
            ),
            Material(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 8.0),
                    color: Theme.of(context).colorScheme.scrollBackground,
                    child: _submitButton()
                  )
                ],
              )
            )
          ],
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).colorScheme.surface, width: 1.5)
          )
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  Widget _textField() {
    return TextField(
      key: Key("messageFieldKey"),
      cursorColor: Colors.black,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      controller: _controller,
      focusNode: _inputFocusNode,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: SizeConfig.getWidth(5)
      ),
      decoration: InputDecoration.collapsed(
        hintText: 'Type message',
        hintStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: SizeConfig.getWidth(5)
        )
      ),
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _inputFocusNode.unfocus()
    );
  }

  Widget _submitButton() {
    return BlocBuilder<MessageInputBloc, MessageInputState>(
      builder: (context, state) {
        return !state.isSubmitting
        ? IconButton(
            key: Key("submitButtonKey"),
            icon: Icon(Icons.send), 
            iconSize: SizeConfig.getWidth(8),
            onPressed: state.isInputValid 
              ? () => _submitButtonPressed()
              : null,
            color: Theme.of(context).colorScheme.callToAction,
          )
        : CircularProgressIndicator();
      }
    );
  }

  void _onInputChanged() {
    _messageInputBloc.add(MessageChanged(message: _controller.text));
  }

  void _onScrollChange() {
    if (widget._scrollController.offset >= 100 && _inputFocusNode.hasFocus) {
      _inputFocusNode.unfocus();
    }
  }

  void _submitButtonPressed() {
    _messageInputBloc.add(Submitted(message: _controller.text, helpTicketIdentifier: widget._ticketIdentifier));
    _controller.clear();
  }

  void _showSnackbar({required String error}) async {
    final SnackBar snackBar = SnackBar(
      key: Key("newReplySnackbarKey"),
      content: Row(
        children: [
          Expanded(
            child: BoldText4(text: error, context: context, color: Theme.of(context).colorScheme.onSecondary)
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.error
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) => _messageInputBloc.add(Reset()));
  }
}