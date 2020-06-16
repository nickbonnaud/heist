import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/profile_setup_screen/bloc/profile_setup_screen_bloc.dart';
import 'package:heist/screens/profile_setup_screen/widgets/pages/setup_tip_screen.dart/bloc/setup_tip_screen_bloc.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:vibrate/vibrate.dart';

class SetupTipBody extends StatefulWidget {
  final AnimationController _controller;

  SetupTipBody({@required AnimationController controller})
    : assert(controller != null),
      _controller = controller;
  
  @override
  State<SetupTipBody> createState() => _SetupTipBodyState();
}

class _SetupTipBodyState extends State<SetupTipBody> {
  TextEditingController _tipRateController = TextEditingController(text: "15");
  final FocusNode _tipRateNode = FocusNode();
  TextEditingController _quickTipRateController = TextEditingController(text: "5");
  final FocusNode _quickTipRateNode = FocusNode();

  bool get isPopulated => _tipRateController.text.isNotEmpty && _quickTipRateController.text.isNotEmpty;

  SetupTipScreenBloc _setupTipScreenBloc;

  @override
  void initState() {
    super.initState();
    _setupTipScreenBloc = BlocProvider.of<SetupTipScreenBloc>(context);
    _tipRateController.addListener(_onTipRateChanged);
    _quickTipRateController.addListener(_onQuickTipRateChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<SetupTipScreenBloc, SetupTipScreenState>(
      listener: (context, state) {
        if (state.isFailure) {
          _showSnackbar(context, 'Failed to save. Please try again.', state);
        } else if (state.isSuccess) {
          _showSnackbar(context, 'Tip Settings Saved!', state);
        }
      },
      child: BlocBuilder<ProfileSetupScreenBloc, ProfileSetupScreenState>(
        builder: (context, state) {
          if (!state.isPaymentAccountComplete) {
            return _buildForm();
          }
          return KeyboardActions(
            config: _buildKeyboard(context),
            child: _buildForm(),
          );
        }
      ),
    );
  }

  @override
  void dispose() {
    _tipRateController.dispose();
    _quickTipRateController.dispose();
    widget._controller.removeStatusListener(_animationListener);
    super.dispose();
  }

  void _onTipRateChanged() {
    String rate = _tipRateController.text != "" ? _tipRateController.text : "0";
    _setupTipScreenBloc.add(TipRateChanged(tipRate: int.parse(rate)));
  }

  void _onQuickTipRateChanged() {
    String rate = _tipRateController.text != "" ? _tipRateController.text : "0";
    _setupTipScreenBloc.add(QuickTipRateChanged(quickTipRate: int.parse(rate)));
  }

  bool _isSaveButtonEnabled(SetupTipScreenState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  void _saveButtonPressed(BuildContext context, SetupTipScreenState state) {
    if (_isSaveButtonEnabled(state)) {
      _setupTipScreenBloc.add(Submitted(
        customer: BlocProvider.of<AuthenticationBloc>(context).customer,
        tipRate: int.parse(_tipRateController.text),
        quickTipRate: int.parse(_quickTipRateController.text)
      ));
    }
  }

  void _showSnackbar(BuildContext context, String message, SetupTipScreenState state) async {
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(state.isSuccess ? FeedbackType.success : FeedbackType.error);
    }

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: Duration(seconds: 1),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: BoldText(text: message, size: SizeConfig.getWidth(6), color: Colors.white)
              ),
              PlatformWidget(
                android: (_) => Icon(state.isSuccess ? Icons.check_circle_outline : Icons.error),
                ios: (_) => Icon(
                  IconData(
                    state.isSuccess ? 0xF3FE : 0xF35B,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  ),
                  color: Colors.white,
                ),
              )
            ],
          ),
          backgroundColor: state.isSuccess ? Colors.green : Colors.red,
        )
      ).closed.then((_) => {
        if (state.isSuccess) {
          widget._controller.addStatusListener(_animationListener),
          widget._controller.forward()
        } else {
          BlocProvider.of<SetupTipScreenBloc>(context).add(Reset())
        }
      });
  }

  Widget _buildForm() {
    return Form(
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, bottom: 16, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(height: SizeConfig.getHeight(15)),
                BoldText.veryBold(
                  text: 'Next, set your tip rates!', 
                  size: SizeConfig.getWidth(6), 
                  color: Colors.black
                ),
                SizedBox(height: SizeConfig.getHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: BlocBuilder<SetupTipScreenBloc, SetupTipScreenState>(
                        builder: (context, state) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Default Tip Rate',
                              suffix: PlatformText(
                                '%',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w700,
                                  fontSize: SizeConfig.getWidth(7)
                                ),
                              ),
                              labelStyle: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: SizeConfig.getWidth(5)
                              )
                            ),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              fontSize: SizeConfig.getWidth(7)
                            ),
                            controller: _tipRateController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            autocorrect: false,
                            autovalidate: true,
                            textAlign: TextAlign.center,
                            focusNode: _tipRateNode,
                            validator: (_) => !state.isTipRateValid ? 'Must be between 0 and 30' : null,
                          );
                        }
                      )
                    ),
                    SizedBox(width: SizeConfig.getWidth(10)),
                    Expanded(
                      child: BlocBuilder<SetupTipScreenBloc, SetupTipScreenState>(
                        builder: (context, state) {
                          return TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Quick Tip Rate',
                              suffix: PlatformText(
                                '%',
                                style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.w700,
                                  fontSize: SizeConfig.getWidth(7)
                                ),
                              ),
                              labelStyle: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: SizeConfig.getWidth(5)
                              )
                            ),
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w700,
                              fontSize: SizeConfig.getWidth(7)
                            ),
                            controller: _quickTipRateController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            autocorrect: false,
                            autovalidate: true,
                            textAlign: TextAlign.center,
                            focusNode: _quickTipRateNode,
                            validator: (_) => !state.isQuickTipRateValid ? 'Must be between 0 and 30' : null,
                          );
                        },
                      )
                    )
                  ],
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: BlocBuilder<SetupTipScreenBloc, SetupTipScreenState>(
                    builder: (context, state) {
                      return RaisedButton(
                        color: Colors.green,
                        disabledColor: Colors.green.shade100,
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: _isSaveButtonEnabled(state) ? () => _saveButtonPressed(context, state) : null,
                        child: _createButtonText(state),
                      );
                    }
                  )
                )
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _createButtonText(SetupTipScreenState state) {
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
                  child: BoldText(text: 'Done', size: SizeConfig.getWidth(4), color: Theme.of(context).primaryColor),
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
                  child: BoldText(text: 'Done', size: SizeConfig.getWidth(4), color: Theme.of(context).primaryColor),
                ),
              );
            }
          ]
        ),
      ]
    );
  }

  void _animationListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      BlocProvider.of<ProfileSetupScreenBloc>(context).add(SectionCompleted(section: Section.tip));
    }
  }
}