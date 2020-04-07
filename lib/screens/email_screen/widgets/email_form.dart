import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/email_screen/bloc/email_form_bloc.dart';
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
          child: ListView(
            children: <Widget>[
              SizedBox(height: SizeConfig.getHeight(5)),
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.getWidth(5)),
                child: BoldText(text: 'Edit Email', size: SizeConfig.getWidth(9), color: Colors.black),
              ),
              SizedBox(height: SizeConfig.getHeight(25)),
              BlocBuilder<EmailFormBloc, EmailFormState>(
                builder: (context, state) {
                  return TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: SizeConfig.getWidth(6)
                      )
                    ),
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.getWidth(7)
                    ),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) => !state.isEmailValid ? 'Invalid email' : null,
                  );
                }
              ),
              SizedBox(height: SizeConfig.getHeight(34)),
              Row(
                children: <Widget>[
                  Expanded(
                    child: BlocBuilder<EmailFormBloc, EmailFormState>(
                      builder: (context, state) {
                        return OutlineButton(
                          borderSide: BorderSide(
                            color: Colors.black
                          ),
                          disabledBorderColor: Colors.grey.shade500,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(context),
                          child: BoldText(text: 'Cancel', size: SizeConfig.getWidth(6), color: state.isSubmitting ? Colors.grey.shade500 : Colors.black),
                        );
                      }
                    ),
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: BlocBuilder<EmailFormBloc, EmailFormState>(
                      builder: (context, state) {
                        return RaisedButton(
                          color: Colors.green,
                          disabledColor: Colors.green.shade100,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: _isSaveButtonEnabled(state) ? () => _saveButtonPressed(state) : null,
                          child: _createButtonText(state),
                        );
                      }
                    ) 
                  ),
                ],
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
                child: BoldText(text: text, size: SizeConfig.getWidth(6), color: Colors.white)
              ),
              PlatformWidget(
                android: (_) => Icon(isSuccess ? Icons.check_circle_outline : Icons.error),
                ios: (_) => Icon(
                  IconData(
                    isSuccess ? 0xF3FE : 0xF35B,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  ),
                  color: Colors.white,
                ),
              )
            ],
          ),
          backgroundColor: isSuccess ? Colors.green : Colors.red,
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
        textStyle: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: SizeConfig.getWidth(6),
            fontWeight: FontWeight.w700
          ),
          color: Colors.white
        ),
      );
    } else {
      return BoldText(text: 'Save', size: SizeConfig.getWidth(6), color: Colors.white);
    }
  }
}