import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/message_input_bloc.dart';

class MessageInput extends StatefulWidget {
  final String _ticketIdentifier;
  final ScrollController _scrollController;

  const MessageInput({required String ticketIdentifier, required ScrollController scrollController, Key? key})
    : _ticketIdentifier = ticketIdentifier,
      _scrollController = scrollController,
      super(key: key);

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
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).colorScheme.surface, width: 1.5)
          )
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 8.w, top: 8.h),
                child: _textField()
              )
            ),
            Material(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 8.w),
                    color: Theme.of(context).colorScheme.scrollBackground,
                    child: _submitButton()
                  )
                ],
              )
            )
          ],
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
      key: const Key("messageFieldKey"),
      cursorColor: Colors.black,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 3,
      controller: _controller,
      focusNode: _inputFocusNode,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 22.sp
      ),
      decoration: InputDecoration.collapsed(
        hintText: 'Type message',
        hintStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 22.sp,
        ),
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
            key: const Key("submitButtonKey"),
            icon: const Icon(Icons.send), 
            iconSize: 40.sp,
            onPressed: state.isInputValid 
              ? () => _submitButtonPressed()
              : null,
            color: Theme.of(context).colorScheme.callToAction,
          )
        : const CircularProgressIndicator();
      }
    );
  }

  void _onInputChanged() {
    _messageInputBloc.add(MessageChanged(message: _controller.text));
  }

  void _onScrollChange() {
    if (widget._scrollController.offset >= 100.h && _inputFocusNode.hasFocus) {
      _inputFocusNode.unfocus();
    }
  }

  void _submitButtonPressed() {
    _messageInputBloc.add(Submitted(message: _controller.text, helpTicketIdentifier: widget._ticketIdentifier));
    _controller.clear();
  }

  void _showSnackbar({required String error}) async {
    final SnackBar snackBar = SnackBar(
      key: const Key("newReplySnackbarKey"),
      content: Row(
        children: [
          Expanded(
            child: SnackbarText(text: error)
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