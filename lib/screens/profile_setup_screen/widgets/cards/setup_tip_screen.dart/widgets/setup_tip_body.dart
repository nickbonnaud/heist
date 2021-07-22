import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:heist/screens/profile_setup_screen/widgets/cards/setup_tip_screen.dart/bloc/setup_tip_card_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

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
          _showSnackbar(context, state.errorMessage, state);
        } else if (state.isSuccess) {
          _showSnackbar(context, 'Tip Settings Saved!', state);
        }
      },
      child: Form(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, bottom: 16, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: KeyboardActions(
                  config: _buildKeyboard(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      VeryBoldText4(
                        text: 'Next, set your tip rates!', 
                        context: context, 
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: _defaultTipRateField()
                          ),
                          SizedBox(width: SizeConfig.getWidth(10)),
                          Expanded(
                            child: _quickTipRateField()
                          )
                        ],
                      ),
                      SizedBox(height: SizeConfig.getHeight(1)),
                    ],
                  ),
                )
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _submitButton()
                  )
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
    );
  }

  Widget _quickTipRateField() {
    return BlocBuilder<SetupTipCardBloc, SetupTipCardState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("quickTipRateFieldKey"),
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
          onPressed: _isSaveButtonEnabled(state) ? () => _saveButtonPressed(context, state) : null,
          child: _buttonChild(state),
        );
      }
    );
  }

  void _onTipRateChanged() {
    _setupTipCardBloc.add(TipRateChanged(tipRate: _tipRateController.text));
  }

  void _onQuickTipRateChanged() {
    _setupTipCardBloc.add(QuickTipRateChanged(quickTipRate: _quickTipRateController.text));
  }

  bool _isSaveButtonEnabled(SetupTipCardState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _saveButtonPressed(BuildContext context, SetupTipCardState state) {
    if (_isSaveButtonEnabled(state)) {
      _setupTipCardBloc.add(Submitted(
        accountIdentifier: widget._accountIdentifier,
        tipRate: int.parse(_tipRateController.text),
        quickTipRate: int.parse(_quickTipRateController.text)
      ));
    }
  }

  void _showSnackbar(BuildContext context, String message, SetupTipCardState state) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: Key("tipsSnackBarKey"),
      duration: Duration(seconds: 1),
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
          BlocProvider.of<ProfileSetupScreenBloc>(context).add(SectionCompleted(section: Section.tip))
        } else {
          BlocProvider.of<SetupTipCardBloc>(context).add(Reset())
        }
      }
    );
  }

  Widget _buttonChild(SetupTipCardState state) {
    if (state.isSubmitting) {
      return SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator());
    } else {
      return BoldText3(text: 'Save', context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
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