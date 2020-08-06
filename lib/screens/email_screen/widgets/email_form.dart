import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/email_screen/bloc/email_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:vibrate/vibrate.dart';

class EmailForm extends StatefulWidget {
  final Customer _customer;

  EmailForm({@required Customer customer})
    : assert(customer != null),
      _customer = customer;

  @override
  State<EmailForm> createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  TextEditingController _emailController;
  final FocusNode _emailFocusNode = FocusNode();

  EmailFormBloc _emailFormBloc;
  
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
        } else if (state.isFailure) {
          _showSnackbar(context: context, isSuccess: false);
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
                      BlocBuilder<EmailFormBloc, EmailFormState>(
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
                            autovalidate: true,
                            focusNode: _emailFocusNode,
                            validator: (_) => !state.isEmailValid ? 'Invalid email' : null,
                          );
                        }
                      ),
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
                      child: BlocBuilder<EmailFormBloc, EmailFormState>(
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
                        }
                      ),
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: BlocBuilder<EmailFormBloc, EmailFormState>(
                        builder: (context, state) {
                          return RaisedButton(
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: _isSaveButtonEnabled(state) ? () => _saveButtonPressed(state) : null,
                            child: _createButtonText(state),
                          );
                        }
                      ) 
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
    super.dispose();
  }

  void _showSnackbar({@required BuildContext context, @required bool isSuccess}) async {
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(isSuccess ? FeedbackType.success : FeedbackType.error);
    }

    final String text = isSuccess
      ? 'Email Updated!'
      : 'Failed to save new email. Please try again.';

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: BoldText3(text: text, context: context, color: Theme.of(context).colorScheme.onSecondary)
              ),
              PlatformWidget(
                android: (_) => Icon(isSuccess ? Icons.check_circle_outline : Icons.error),
                ios: (_) => Icon(
                  IconData(
                    isSuccess ? 0xF3FE : 0xF35B,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  ),
                  color: Theme.of(context).colorScheme.onError,
                ),
              )
            ],
          ),
          backgroundColor: isSuccess
            ? Theme.of(context).colorScheme.success
            : Theme.of(context).colorScheme.error,
        )
      ).closed.then((_) => {
        if (isSuccess) {
          Navigator.of(context).pop()
        } else {
          BlocProvider.of<EmailFormBloc>(context).add(Reset())
        }
      });
  }

  void _cancelButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }

  bool _isSaveButtonEnabled(EmailFormState state) {
    return state.isEmailValid && _emailChanged() && _emailController.text.isNotEmpty && !state.isSubmitting;
  }

  bool _emailChanged() {
    return widget._customer?.email != _emailController.text;
  }

  void _onEmailChanged() {
    _emailFormBloc.add(EmailChanged(email: _emailController.text));
  }
  
  void _saveButtonPressed(EmailFormState state) {
    if (_isSaveButtonEnabled(state)) {
      _emailFormBloc.add(Submitted(customer: widget._customer, email: _emailController.text));
    }
  }

  Widget _createButtonText(EmailFormState state) {
    if (state.isSubmitting) {
      return TyperAnimatedTextKit(
        speed: Duration(milliseconds: 250),
        text: ['Saving...'],
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: SizeConfig.getWidth(6)
        ),
      );
    } else {
      return BoldText3(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
  }

  KeyboardActionsConfig _buildKeyboard(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardAction(
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