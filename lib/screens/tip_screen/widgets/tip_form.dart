import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/tip_screen/bloc/tip_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:vibrate/vibrate.dart';

class TipForm extends StatefulWidget {
  final Customer _customer;

  TipForm({@required Customer customer})
    : assert(customer != null),
      _customer = customer;

  @override
  State<TipForm> createState() => _TipFormState();
}

class _TipFormState extends State<TipForm> {
  TextEditingController _tipRateController = TextEditingController();
  final FocusNode _tipRateNode = FocusNode();
  TextEditingController _quickTipRateController = TextEditingController();
  final FocusNode _quickTipRateNode = FocusNode();

  bool get isPopulated => _tipRateController.text.isNotEmpty && _quickTipRateController.text.isNotEmpty;

  TipFormBloc _tipFormBloc;

  @override
  void initState() {
    super.initState();
    _tipFormBloc = BlocProvider.of<TipFormBloc>(context);
    _tipRateController = TextEditingController(text: widget._customer.account.tipRate.toString());
    _quickTipRateController = TextEditingController(text: widget._customer.account.quickTipRate.toString());

    _tipRateController.addListener(_onTipRateChanged);
    _quickTipRateController.addListener(_onQuickTipRateChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<TipFormBloc, TipFormState>(
      listener: (context, state) {
        if (state.isFailure) {
          _showSnackbar(context, 'Failed to save. Please try again.', state);
        } else if (state.isSuccess) {
          _showSnackbar(context, 'Account Updated!', state);
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
                      VeryBoldText1(
                        text: 'Edit Tip Rates', 
                        context: context, 
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: BlocBuilder<TipFormBloc, TipFormState>(
                              builder: (context, state) {
                                return TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Default Tip Rate',
                                    suffix: PlatformText(
                                      '%',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: SizeConfig.getWidth(7)
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: SizeConfig.getWidth(5)
                                    )
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: SizeConfig.getWidth(7)
                                  ),
                                  controller: _tipRateController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  autocorrect: false,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  textAlign: TextAlign.center,
                                  focusNode: _tipRateNode,
                                  validator: (_) => !state.isTipRateValid ? 'Must be between 0 and 30' : null,
                                );
                              }
                            )
                          ),
                          SizedBox(width: SizeConfig.getWidth(10)),
                          Expanded(
                            child: BlocBuilder<TipFormBloc, TipFormState>(
                              builder: (context, state) {
                                return TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Quick Tip Rate',
                                    suffix: PlatformText(
                                      '%',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: SizeConfig.getWidth(7)
                                      ),
                                    ),
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: SizeConfig.getWidth(5)
                                    )
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: SizeConfig.getWidth(7)
                                  ),
                                  controller: _quickTipRateController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  autocorrect: false,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  textAlign: TextAlign.center,
                                  focusNode: _quickTipRateNode,
                                  validator: (_) => !state.isQuickTipRateValid ? 'Must be between 0 and 30' : null,
                                );
                              }
                            )
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.getHeight(1)),
                    ],
                  ),
                ) ,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: BlocBuilder<TipFormBloc, TipFormState>(
                        builder: (context, state) {
                          return OutlinedButton(
                            onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(context),
                            child: BoldText3(
                              text: 'Cancel', 
                              context: context, 
                              color: state.isSubmitting 
                                ? Theme.of(context).colorScheme.callToActionDisabled
                                : Theme.of(context).colorScheme.callToAction
                            ),
                          );
                        }
                      )
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: BlocBuilder<TipFormBloc, TipFormState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: _isSaveButtonEnabled(state) ? () => _saveButtonPressed(state) : null,
                            child: _createButtonText(state),
                          );
                        }
                      ) 
                    ),
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
    _tipRateController.dispose();
    _quickTipRateController.dispose();
    super.dispose();
  }

  Widget _createButtonText(TipFormState state) {
    if (state.isSubmitting) {
      return TyperAnimatedTextKit(
        speed: Duration(milliseconds: 250),
        text: ['Saving...'],
        textStyle: TextStyle(
          fontSize: SizeConfig.getWidth(6),
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      );
    } else {
      return BoldText3(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
  }

  void _onTipRateChanged() {
    _tipFormBloc.add(TipRateChanged(tipRate: int.parse(_tipRateController.text)));
  }

  void _onQuickTipRateChanged() {
    _tipFormBloc.add(QuickTipRateChanged(quickTipRate: int.parse(_quickTipRateController.text)));
  }

  void _cancelButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }

  bool _isSaveButtonEnabled(TipFormState state) {
    return state.isFormValid && _formFieldsChanged() && isPopulated && !state.isSubmitting;
  }

  bool _formFieldsChanged() {
    return (widget._customer.account.tipRate != int.parse(_tipRateController.text))
      || (widget._customer.account.quickTipRate != int.parse(_quickTipRateController.text));
  }

  void _saveButtonPressed(TipFormState state) {
    if (_isSaveButtonEnabled(state)) {
      _tipFormBloc.add(Submitted(
        customer: widget._customer,
        tipRate: int.parse(_tipRateController.text) != widget._customer.account.tipRate ? int.parse(_tipRateController.text) : null,
        quickTipRate: int.parse(_quickTipRateController.text) != widget._customer.account.quickTipRate ? int.parse(_quickTipRateController.text) : null
      ));
    }
  }

  void _showSnackbar(BuildContext context, String message, TipFormState state) async {
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
            ],
          ),
          backgroundColor: state.isSuccess
            ? Theme.of(context).colorScheme.success
            : Theme.of(context).colorScheme.error,
        )
      ).closed.then((_) => {
        if (state.isSuccess) {
          Navigator.of(context).pop()
        } else {
          BlocProvider.of<TipFormBloc>(context).add(Reset())
        }
      });
  }

  KeyboardActionsConfig _buildKeyboard(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardAction(
          focusNode: _tipRateNode,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).primaryColor),
                ),
              );
            }
          ]
        ),
        KeyboardAction(
          focusNode: _quickTipRateNode,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).primaryColor),
                ),
              );
            }
          ]
        ),
      ]
    );
  }
}