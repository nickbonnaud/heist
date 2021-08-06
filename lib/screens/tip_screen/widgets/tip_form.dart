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
          _showSnackbar(message: state.errorMessage, state: state);
        } else if (state.isSuccess) {
          _showSnackbar(message: 'Account Updated!', state: state);
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
                  config: _buildKeyboard(),
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
                            child: _defaultTip()
                          ),
                          SizedBox(width: SizeConfig.getWidth(10)),
                          Expanded(
                            child: _quickTip()
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
                      child: _cancelButton()
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: _submitButton() 
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

    _tipRateNode.dispose();
    _quickTipRateNode.dispose();
    super.dispose();
  }

  Widget _defaultTip() {
    return BlocBuilder<TipFormBloc, TipFormState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("defaultTipFieldKey"),
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
          validator: (_) => !state.isTipRateValid 
            ? 'Must be between 0 and 30' 
            : null,
        );
      }
    );
  }

  Widget _quickTip() {
    return BlocBuilder<TipFormBloc, TipFormState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("quickTipFieldKey"),
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
          validator: (_) => !state.isQuickTipRateValid
            ? 'Must be between 0 and 20'
            : null,
        );
      }
    );
  }

  Widget _cancelButton() {
    return BlocBuilder<TipFormBloc, TipFormState>(
      builder: (context, state) {
        return OutlinedButton(
          key: Key("cancelButtonKey"),
          onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(),
          child: BoldText3(
            text: 'Cancel', 
            context: context, 
            color: state.isSubmitting 
              ? Theme.of(context).colorScheme.callToActionDisabled
              : Theme.of(context).colorScheme.callToAction
          ),
        );
      }
    );
  }

  Widget _submitButton() {
    return BlocBuilder<TipFormBloc, TipFormState>(
      builder: (context, state) {
        return ElevatedButton(
          key: Key("submitButtonKey"),
          onPressed: _isSaveButtonEnabled(state: state) ? () => _saveButtonPressed(state: state) : null,
          child: _buttonChild(state: state),
        );
      }
    );
  }
  
  Widget _buttonChild({required TipFormState state}) {
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

  void _cancelButtonPressed() {
    Navigator.pop(context);
  }

  bool _isSaveButtonEnabled({required TipFormState state}) {
    return state.isFormValid && _formFieldsChanged() && isPopulated && !state.isSubmitting;
  }

  bool _formFieldsChanged() {
    return (widget._account.tipRate != int.parse(_tipRateController.text))
      || (widget._account.quickTipRate != int.parse(_quickTipRateController.text));
  }

  void _saveButtonPressed({required TipFormState state}) {
    if (_isSaveButtonEnabled(state: state)) {
      _tipFormBloc.add(Submitted(
        accountIdentifier: widget._account.identifier,
        tipRate: int.parse(_tipRateController.text) != widget._account.tipRate ? int.parse(_tipRateController.text) : null,
        quickTipRate: int.parse(_quickTipRateController.text) != widget._account.quickTipRate ? int.parse(_quickTipRateController.text) : null
      ));
    }
  }

  void _showSnackbar({required String message, required TipFormState state}) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: Key("tipFormSnackbarKey"),
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

  KeyboardActionsConfig _buildKeyboard() {
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