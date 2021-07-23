import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/customer/account.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/tip_screen/bloc/tip_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class TipForm extends StatefulWidget {
  final Account _account;

  TipForm({required Account account})
    : _account = account;

  @override
  State<TipForm> createState() => _TipFormState();
}

class _TipFormState extends State<TipForm> {
  TextEditingController _tipRateController = TextEditingController();
  final FocusNode _tipRateNode = FocusNode();
  TextEditingController _quickTipRateController = TextEditingController();
  final FocusNode _quickTipRateNode = FocusNode();

  bool get isPopulated => _tipRateController.text.isNotEmpty && _quickTipRateController.text.isNotEmpty;

  late TipFormBloc _tipFormBloc;

  @override
  void initState() {
    super.initState();
    _tipFormBloc = BlocProvider.of<TipFormBloc>(context);
    _tipRateController = TextEditingController(text: widget._account.tipRate.toString());
    _quickTipRateController = TextEditingController(text: widget._account.quickTipRate.toString());

    _tipRateController.addListener(_onTipRateChanged);
    _quickTipRateController.addListener(_onQuickTipRateChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<TipFormBloc, TipFormState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          _showSnackbar(context, state.errorMessage, state);
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
                            child: _buttonChild(state),
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

  Widget _buttonChild(TipFormState state) {
    if (state.isSubmitting) {
      return SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator()); 
    } else {
      return BoldText3(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
  }

  void _onTipRateChanged() {
    _tipFormBloc.add(TipRateChanged(tipRate: _tipRateController.text));
  }

  void _onQuickTipRateChanged() {
    _tipFormBloc.add(QuickTipRateChanged(quickTipRate: _quickTipRateController.text));
  }

  void _cancelButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }

  bool _isSaveButtonEnabled(TipFormState state) {
    return state.isFormValid && _formFieldsChanged() && isPopulated && !state.isSubmitting;
  }

  bool _formFieldsChanged() {
    return (widget._account.tipRate != int.parse(_tipRateController.text))
      || (widget._account.quickTipRate != int.parse(_quickTipRateController.text));
  }

  void _saveButtonPressed(TipFormState state) {
    if (_isSaveButtonEnabled(state)) {
      _tipFormBloc.add(Submitted(
        accountIdentifier: widget._account.identifier,
        tipRate: int.parse(_tipRateController.text) != widget._account.tipRate ? int.parse(_tipRateController.text) : null,
        quickTipRate: int.parse(_quickTipRateController.text) != widget._account.quickTipRate ? int.parse(_quickTipRateController.text) : null
      ));
    }
  }

  void _showSnackbar(BuildContext context, String message, TipFormState state) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
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
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) => {
        if (state.isSuccess) {
          Navigator.of(context).pop()
        } else {
          BlocProvider.of<TipFormBloc>(context).add(Reset())
        }
      }
    );
  }

  KeyboardActionsConfig _buildKeyboard(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardActionsItem(
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
        KeyboardActionsItem(
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