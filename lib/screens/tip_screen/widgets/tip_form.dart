import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/models/customer/account.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/tip_screen/bloc/tip_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class TipForm extends StatefulWidget {

  const TipForm({Key? key})
    : super(key: key);

  @override
  State<TipForm> createState() => _TipFormState();
}

class _TipFormState extends State<TipForm> {
  final FocusNode _tipRateNode = FocusNode();
  final FocusNode _quickTipRateNode = FocusNode();

  late TipFormBloc _tipFormBloc;

  @override
  void initState() {
    super.initState();
    _tipFormBloc = BlocProvider.of<TipFormBloc>(context);
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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: KeyboardActions(
                  config: _buildKeyboard(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const ScreenTitle(title: 'Edit Tip Rates'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _defaultTip()
                          ),
                          SizedBox(width: 40.w),
                          Expanded(
                            child: _quickTip()
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ) ,
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
        )
      ),
    );
  }

  @override
  void dispose() {
    _tipRateNode.dispose();
    _quickTipRateNode.dispose();

    super.dispose();
  }

  Widget _defaultTip() {
    return BlocBuilder<TipFormBloc, TipFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("defaultTipFieldKey"),
          decoration: InputDecoration(
            labelText: 'Default Tip Rate',
            suffix: Text(
              '%',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28.sp
              ),
            ),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 24.sp
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28.sp
          ),
          initialValue: BlocProvider.of<CustomerBloc>(context).customer!.account.tipRate.toString(),
          onChanged: (tipRate) => _onTipRateChanged(tipRate: tipRate),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textAlign: TextAlign.center,
          focusNode: _tipRateNode,
          validator: (_) => !state.isTipRateValid && state.tipRate.isNotEmpty
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
          key: const Key("quickTipFieldKey"),
          decoration: InputDecoration(
            labelText: 'Quick Tip Rate',
            suffix: Text(
              '%',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28.sp
              ),
            ),
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 24.sp
            )
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28.sp
          ),
          initialValue: BlocProvider.of<CustomerBloc>(context).customer!.account.quickTipRate.toString(),
          onChanged: (quickTipRate) => _onQuickTipRateChanged(quickTipRate: quickTipRate),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textAlign: TextAlign.center,
          focusNode: _quickTipRateNode,
          validator: (_) => !state.isQuickTipRateValid && state.quickTipRate.isNotEmpty
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
          key: const Key("cancelButtonKey"),
          onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(),
          child: ButtonText(text: 'Cancel', color: state.isSubmitting
            ? Theme.of(context).colorScheme.callToActionDisabled
            : Theme.of(context).colorScheme.callToAction
          )
        );
      }
    );
  }

  Widget _submitButton() {
    return BlocBuilder<TipFormBloc, TipFormState>(
      builder: (context, state) {
        return ElevatedButton(
          key: const Key("submitButtonKey"),
          onPressed: _isSaveButtonEnabled(state: state) ? () => _saveButtonPressed(state: state) : null,
          child: _buttonChild(state: state),
        );
      }
    );
  }
  
  Widget _buttonChild({required TipFormState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: 25.sp, width: 25.sp, child: const CircularProgressIndicator()); 
    } else {
      return const ButtonText(text: 'Save');
    }
  }

  void _onTipRateChanged({required String tipRate}) {
    _tipFormBloc.add(TipRateChanged(tipRate: tipRate));
  }

  void _onQuickTipRateChanged({required String quickTipRate}) {
    _tipFormBloc.add(QuickTipRateChanged(quickTipRate: quickTipRate));
  }

  void _cancelButtonPressed() {
    Navigator.pop(context);
  }

  bool _isSaveButtonEnabled({required TipFormState state}) {
    return state.isFormValid && _formFieldsChanged(state: state) && !state.isSubmitting;
  }

  bool _formFieldsChanged({required TipFormState state}) {
    Account account = BlocProvider.of<CustomerBloc>(context).customer!.account;
    return (account.tipRate != int.parse(state.tipRate))
      || (account.quickTipRate != int.parse(state.quickTipRate));
  }

  void _saveButtonPressed({required TipFormState state}) {
    if (_isSaveButtonEnabled(state: state)) {
      _tipFormBloc.add(Submitted());
    }
  }

  void _showSnackbar({required String message, required TipFormState state}) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: const Key("tipFormSnackbarKey"),
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
              return TextButton(
                onPressed: () => node.unfocus(), 
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: const ActionText()
                )
              );
            }
          ]
        ),
        KeyboardActionsItem(
          focusNode: _quickTipRateNode,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(), 
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: const ActionText()
                )
              );
            }
          ]
        ),
      ]
    );
  }
}