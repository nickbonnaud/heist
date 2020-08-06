import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/issue_screen/bloc/issue_form_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:vibrate/vibrate.dart';
import 'package:heist/themes/global_colors.dart';

class IssueForm extends StatefulWidget {
  final IssueType _type;
  final TransactionResource _transaction;

  IssueForm({@required IssueType type, @required TransactionResource transaction})
    : assert(type != null && transaction != null),
      _type = type,
      _transaction = transaction;
  
  @override
  State<StatefulWidget> createState() => _IssueFormState();
}

class _IssueFormState extends State<IssueForm> {
  TextEditingController _messageController;
  final FocusNode _messageFocusNode = FocusNode();

  IssueFormBloc _issueFormBloc;

  @override
  void initState() {
    super.initState();
    _issueFormBloc = BlocProvider.of<IssueFormBloc>(context);
    _messageController = TextEditingController();
    _messageController.addListener(_onMessageChanged);
    _messageFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IssueFormBloc, IssueFormState>(
      listener: (context, state) {
        if (state.isFailure) {
          _showSnackbar(context, 'Failed to submit issue!', state);
        } else if (state.isSuccess) {
          _showSnackbar(context, 'Issue created.', state);
        }
      },
      child: Form(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: KeyboardActions(
              config: _buildKeyboard(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(height: SizeConfig.getHeight(3)),
                      BoldTextCustom(text: _formatIssueType(), context: context, size: SizeConfig.getWidth(9)),
                      SizedBox(height: SizeConfig.getHeight(15)),
                      BlocBuilder<IssueFormBloc, IssueFormState>(
                        builder: (context, state) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: "Issue",
                              labelStyle: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: SizeConfig.getWidth(6)
                              )
                            ),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              fontSize: SizeConfig.getWidth(7)
                            ),
                            controller: _messageController,
                            focusNode: _messageFocusNode,
                            keyboardType: TextInputType.multiline,
                            autocorrect: true,
                            autovalidate: true,
                            validator: (_) => !state.isMessageValid && _messageController.text.length != 0 ? 'Issue must be at least 5 characters long' : null,
                            maxLines: null,
                          );
                        },
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: BlocBuilder<IssueFormBloc, IssueFormState>(
                            builder: (context, state) {
                              return OutlineButton(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.callToAction
                                ),
                                disabledBorderColor: Theme.of(context).colorScheme.callToActionDisabled,
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(context),
                                child: BoldText3(text: 'Cancel', context: context, color: state.isSubmitting 
                                  ? Theme.of(context).colorScheme.callToActionDisabled
                                  : Theme.of(context).colorScheme.callToAction
                                ),
                              );
                            },
                          )
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: BlocBuilder<IssueFormBloc, IssueFormState>(
                            builder: (context, state) {
                              return RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                onPressed: _isSaveButtonEnabled(state) ? () => _saveButtonPressed(state) : null,
                                child: _createButtonText(context: context, state: state),
                              );
                            }
                          ) 
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
    _messageController.dispose();
    super.dispose();
  }

  void _onMessageChanged() {
    _issueFormBloc.add(MessageChanged(message: _messageController.text));
  }

  bool _isSaveButtonEnabled(IssueFormState state) {
    return state.isMessageValid && _messageController.text.isNotEmpty && !state.isSubmitting;
  }
  
  void _cancelButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void _saveButtonPressed(IssueFormState state) {
    if (_isSaveButtonEnabled(state)) {
      _messageFocusNode.unfocus();
      _issueFormBloc.add(Submitted(
        message: _messageController.text, 
        type: widget._type, 
        transaction: widget._transaction
      ));
    }
  }

  Widget _createButtonText({@required BuildContext context, @required IssueFormState state}) {
    if (state.isSubmitting) {
      return TyperAnimatedTextKit(
        speed: Duration(milliseconds: 250),
        text: ['Submitting...'],
        textStyle: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: SizeConfig.getWidth(6),
            fontWeight: FontWeight.w700
          ),
          color: Theme.of(context).colorScheme.onSecondary
        ),
      );
    } else {
      return BoldText3(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
  }

  void _showSnackbar(BuildContext context, String message, IssueFormState state) async {
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(state.isSuccess ? FeedbackType.success : FeedbackType.error);
    }

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: BoldText3(text: message, context: context, color: Theme.of(context).colorScheme.onSecondary)
              ),
              PlatformWidget(
                android: (_) => Icon(state.isSuccess ? Icons.check_circle_outline : Icons.error),
                ios: (_) => Icon(
                  IconData(
                    state.isSuccess ? 0xF3FE : 0xF35B,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  ),
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              )
            ],
          ),
          backgroundColor: state.isSuccess 
            ? Theme.of(context).colorScheme.success
            : Theme.of(context).colorScheme.error,
        )
      ).closed.then((_) => {
        if (state.isSuccess) {
          Navigator.of(context).pop(state.transactionResource)
        } else {
          BlocProvider.of<IssueFormBloc>(context).add(Reset())
        }
      });
  }

  String _formatIssueType() {
    if (widget._type == IssueType.wrong_bill) {
      return 'Wrong Bill';
    } else if (widget._type == IssueType.error_in_bill) {
      return "Something's wrong";
    } else {
      return "What's wrong?";
    }
  }

  KeyboardActionsConfig _buildKeyboard(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardAction(
          displayArrows: false,
          focusNode: _messageFocusNode,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).primaryColor),
                ),
              );
            }
          ]
        )
      ]
    );
  }
}