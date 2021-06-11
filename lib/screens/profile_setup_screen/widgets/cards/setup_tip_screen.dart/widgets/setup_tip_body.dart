import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:heist/screens/profile_setup_screen/widgets/cards/setup_tip_screen.dart/bloc/setup_tip_card_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class SetupTipBody extends StatefulWidget {
  
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
    return BlocListener<SetupTipCardBloc, SetupTipScreenState>(
      listener: (context, state) {
        if (state.isFailure) {
          _showSnackbar(context, 'Failed to save. Please try again.', state);
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
                            child: BlocBuilder<SetupTipCardBloc, SetupTipScreenState>(
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
                            child: BlocBuilder<SetupTipCardBloc, SetupTipScreenState>(
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
                              },
                            )
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
                    child: BlocBuilder<SetupTipCardBloc, SetupTipScreenState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: _isSaveButtonEnabled(state) ? () => _saveButtonPressed(context, state) : null,
                          child: _buttonChild(state),
                        );
                      }
                    )
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
    super.dispose();
  }

  void _onTipRateChanged() {
    String rate = _tipRateController.text != "" ? _tipRateController.text : "0";
    _setupTipCardBloc.add(TipRateChanged(tipRate: int.parse(rate)));
  }

  void _onQuickTipRateChanged() {
    String rate = _tipRateController.text != "" ? _tipRateController.text : "0";
    _setupTipCardBloc.add(QuickTipRateChanged(quickTipRate: int.parse(rate)));
  }

  bool _isSaveButtonEnabled(SetupTipScreenState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _saveButtonPressed(BuildContext context, SetupTipScreenState state) {
    if (_isSaveButtonEnabled(state)) {
      _setupTipCardBloc.add(Submitted(
        tipRate: int.parse(_tipRateController.text),
        quickTipRate: int.parse(_quickTipRateController.text)
      ));
    }
  }

  void _showSnackbar(BuildContext context, String message, SetupTipScreenState state) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
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

  Widget _buttonChild(SetupTipScreenState state) {
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