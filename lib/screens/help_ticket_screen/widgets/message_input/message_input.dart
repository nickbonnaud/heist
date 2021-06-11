import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
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
  
  late TextEditingController _controller;
  late MessageInputBloc _messageInputBloc;

  bool get isPopulated => _controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _messageInputBloc = BlocProvider.of<MessageInputBloc>(context);
    _controller = TextEditingController();
    _controller.addListener(_onInputChanged);
    widget._scrollController.addListener(_onScrollChange);
    _inputFocusNode.requestFocus();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 8.0, top: 8.0),
              child: TextField(
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
              )
            )
          ),
          Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(right: 8.0),
                  color: Theme.of(context).colorScheme.scrollBackground,
                  child: BlocBuilder<MessageInputBloc, MessageInputState>(
                    builder: (context, state) {
                      return !state.isSubmitting
                      ? IconButton(
                          icon: Icon(Icons.send), 
                          iconSize: SizeConfig.getWidth(8),
                          onPressed: state.isInputValid 
                            ? () => _submitButtonPressed()
                            : null,
                          color: Theme.of(context).colorScheme.callToAction,
                        )
                      : CircularProgressIndicator();
                    }
                  )
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
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
}