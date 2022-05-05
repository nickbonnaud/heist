import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/issue_screen/bloc/issue_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class IssueForm extends StatefulWidget {

  const IssueForm({Key? key})
    : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _IssueFormState();
}

class _IssueFormState extends State<IssueForm> {
  final FocusNode _messageFocusNode = FocusNode();

  late IssueFormBloc _issueFormBloc;

  @override
  void initState() {
    super.initState();
    _issueFormBloc = BlocProvider.of<IssueFormBloc>(context);
    _messageFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IssueFormBloc, IssueFormState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          _showSnackbar(message: state.errorMessage, state: state);
        } else if (state.isSuccess) {
          _showSnackbar(message: 'Issue created.', state: state);
        }
      },
      child: Form(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: KeyboardActions(
              config: _buildKeyboard(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(height: 25.h),
                      ScreenTitle(title: _formatIssueType()),
                      SizedBox(height: 120.h),
                      _inputField()
                    ],
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
                  )
                ],
              ),
            ),
          ) ,
        )
      ),
    );
  }

  @override
  void dispose() {
    _messageFocusNode.dispose();
    super.dispose();
  }

  Widget _inputField() {
    return BlocBuilder<IssueFormBloc, IssueFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("issueFieldKey"),
          decoration: InputDecoration(
            labelText: "Issue",
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 25.sp
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28.sp
          ),
          onChanged: (message) => _onMessageChanged(message: message),
          focusNode: _messageFocusNode,
          keyboardType: TextInputType.multiline,
          autocorrect: true,
          textCapitalization: TextCapitalization.sentences,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) => !state.isMessageValid && state.message.isNotEmpty
            ? 'Issue must be at least 5 characters long'
            : null,
          maxLines: null,
        );
      },
    );
  }

  Widget _cancelButton() {
    return BlocBuilder<IssueFormBloc, IssueFormState>(
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
    return BlocBuilder<IssueFormBloc, IssueFormState>(
      builder: (context, state) {
        return ElevatedButton(
          key: const Key("submitButtonKey"),
          onPressed: _isSaveButtonEnabled(state: state) ? () => _saveButtonPressed(state: state) : null,
          child: _buttonChild(context: context, state: state),
        );
      }
    );
  }

  Widget _buttonChild({required BuildContext context, required IssueFormState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: 25.sp, width: 25.sp, child: const CircularProgressIndicator());
    } else {
      return const ButtonText(text: 'Save');
    }
  }
  
  void _onMessageChanged({required String message}) {
    _issueFormBloc.add(MessageChanged(message: message));
  }

  bool _isSaveButtonEnabled({required IssueFormState state}) {
    return state.formValid && !state.isSubmitting;
  }
  
  void _cancelButtonPressed() {
    Navigator.pop(context);
  }

  void _saveButtonPressed({required IssueFormState state}) {
    if (_isSaveButtonEnabled(state: state)) {
      _messageFocusNode.unfocus();
      state.transactionResource.issue == null 
        ?
          _issueFormBloc.add(Submitted())
        : _issueFormBloc.add(Updated());
    }
  }

  void _showSnackbar({required String message, required IssueFormState state}) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: const Key("snackBarKey"),
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
      .closed.then((_) {
        if (state.isSuccess) {
          Navigator.of(context).pop(state.transactionResource);
        } else {
          BlocProvider.of<IssueFormBloc>(context).add(Reset());
        }
      }
    );
  }

  String _formatIssueType() {
    IssueType type = BlocProvider.of<IssueFormBloc>(context).state.issueType;
    if (type == IssueType.wrongBill) {
      return 'Wrong Bill';
    } else if (type == IssueType.errorInBill) {
      return "Something's wrong";
    } else {
      return "What's wrong?";
    }
  }

  KeyboardActionsConfig _buildKeyboard() {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardActionsItem(
          displayArrows: false,
          focusNode: _messageFocusNode,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: const ActionText()
                ),
              );
            }
          ]
        )
      ]
    );
  }
}