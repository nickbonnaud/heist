import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/title_text.dart';
import '../bloc/setup_tip_card_bloc.dart';

class SetupTipBody extends StatefulWidget {
  final String _accountIdentifier;

  const SetupTipBody({required String accountIdentifier})
    : _accountIdentifier = accountIdentifier;
  
  @override
  State<SetupTipBody> createState() => _SetupTipBodyState();
}

class _SetupTipBodyState extends State<SetupTipBody> {
  late TextEditingController _tipRateController = TextEditingController(text: "15");
  final FocusNode _tipRateNode = FocusNode();
  late TextEditingController _quickTipRateController = TextEditingController(text: "5");
  final FocusNode _quickTipRateNode = FocusNode();

  bool get isPopulated => _tipRateController.text.isNotEmpty && _quickTipRateController.text.isNotEmpty;

  late SetupTipCardBloc _setupTipCardBloc;

  @override
  void initState() {
    super.initState();
    _setupTipCardBloc = BlocProvider.of<SetupTipCardBloc>(context);
    _tipRateController.addListener(_onTipRateChanged);
    _quickTipRateController.addListener(_onQuickTipRateChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<SetupTipCardBloc, SetupTipCardState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          _showSnackbar(context: context, message: state.errorMessage, state: state);
        } else if (state.isSuccess) {
          _showSnackbar(context: context, message: 'Tip Settings Saved!', state: state);
        }
      },
      child: Form(
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, bottom: 16.h, right: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: KeyboardActions(
                  config: _buildKeyboard(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TitleText(text: 'Next, set your tip rates!'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _defaultTipRateField()
                          ),
                          SizedBox(width: 40.w),
                          Expanded(
                            child: _quickTipRateField()
                          )
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                )
              ),
              Row(
                children: [
                  SizedBox(width: .1.sw),
                  Expanded(
                    child: _submitButton()
                  ),
                  SizedBox(width: .1.sw)
                ],
              ),
            ],
          ),
        )
      )
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

  Widget _defaultTipRateField() {
    return BlocBuilder<SetupTipCardBloc, SetupTipCardState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("defaultTipRateFieldKey"),
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
    );
  }

  Widget _quickTipRateField() {
    return BlocBuilder<SetupTipCardBloc, SetupTipCardState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("quickTipRateFieldKey"),
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
          controller: _quickTipRateController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textAlign: TextAlign.center,
          focusNode: _quickTipRateNode,
          validator: (_) => !state.isQuickTipRateValid ? 'Must be between 0 and 20' : null,
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<SetupTipCardBloc, SetupTipCardState>(
      builder: (context, state) {
        return ElevatedButton(
          key: Key("submitTipRatesButtonKey"),
          onPressed: _isSaveButtonEnabled(state: state) ? () => _saveButtonPressed(context: context, state: state) : null,
          child: _buttonChild(state: state),
        );
      }
    );
  }

  Widget _buttonChild({required SetupTipCardState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: 25.sp, width: 25.sp, child: CircularProgressIndicator());
    } else {
      return ButtonText(text: 'Save');
    }
  }

  void _onTipRateChanged() {
    _setupTipCardBloc.add(TipRateChanged(tipRate: _tipRateController.text));
  }

  void _onQuickTipRateChanged() {
    _setupTipCardBloc.add(QuickTipRateChanged(quickTipRate: _quickTipRateController.text));
  }

  bool _isSaveButtonEnabled({required SetupTipCardState state}) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _saveButtonPressed({required BuildContext context, required SetupTipCardState state}) {
    if (_isSaveButtonEnabled(state: state)) {
      _setupTipCardBloc.add(Submitted(
        accountIdentifier: widget._accountIdentifier,
        tipRate: int.parse(_tipRateController.text),
        quickTipRate: int.parse(_quickTipRateController.text)
      ));
    }
  }

  void _showSnackbar({required BuildContext context, required String message, required SetupTipCardState state}) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: Key("tipsSnackBarKey"),
      duration: Duration(seconds: 1),
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
          BlocProvider.of<ProfileSetupScreenBloc>(context).add(SectionCompleted(section: Section.tip))
        } else {
          BlocProvider.of<SetupTipCardBloc>(context).add(Reset())
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
              return TextButton(
                onPressed: () => node.unfocus(), 
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: ActionText()
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
                  child: ActionText()
                )
              );
            }
          ]
        ),
      ]
    );
  }
}