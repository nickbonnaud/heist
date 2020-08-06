import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/global_widgets/dots.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

import 'bloc/slide_changed.dart';
import 'bloc/tutorial_navigation_bloc.dart';

class TutorialScreen extends StatelessWidget {

  final List<String> _images = [
    "assets/slide_1.png",
    "assets/slide_2.png",
    "assets/slide_3.png",
    "assets/slide_4.png",
    "assets/slide_1.png",
    "assets/slide_2.png",
    "assets/slide_3.png",
    "assets/slide_4.png",
    "assets/slide_1.png",
    "assets/slide_2.png"
  ];

  final List<String> _headers = [
    "Learn how to use ${Constants.appName}",
    "At a register",
    "At a restaurant or bar",
    "Approving a transaction",
    "Denying a transaction",
    "Wrong Bill Option",
    "Error in Bill Option",
    "Other Option",
    'FAQs. ',
    'Get Started!'
  ];

  final List<String> _body = [
    "Take a quick tutorial on how to pay using ${Constants.appName}!",
    "Paying at a register is simple! Just tell the cashier you are paying with ${Constants.appName}. They may ask for your name, but thats it!",
    "Paying at a restaurant or bar is actually easier! When you are finished with your meal or drinks, just leave!",
    "Once you receive a notification with your transaction or bill you have the option to approve a payment, with or without a tip, or deny the transaction.",
    "If you wish to deny a transaction you have three selection options. You must choose one of the following options.",
    "The first option is 'Wrong Bill'. This option allows you to select the correct bill from a list of possible bills.",
    "The second option is 'Error in Bill'. Selecting this option allows you to specify the error so the business can resolve the error.",
    "The last option is 'Other'. This options allows you to specify what is wrong. ${Constants.appName} will work with the business and you to resolve the issue.",
    "Q: What happens if you don't respond to a bill notification?\n"
    "A: You will be sent a reminder notification after a period of time, after which if you don't respond to you will automatically charged.\n\n"
    "Q: What if you deny a bill using the option 'Wrong Bill', but fail to choose the correct bill?\n"
    "A: You will be sent three reminder notifications, each after a period of time you fail to respond. After the third notification, you will be automatically charged the full amount.\n\n"
    "Q: Should you tell your server or bartender you are paying with ${Constants.appName}?\n"
    "A: It is not required, but for your server or bartenders state of mind we highly recommend it!",
    "That's it! If you wish to review this walkthrough again you can view it in the app menu."
  ];
  
  final IndexController controller = IndexController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocProvider<TutorialNavigationBloc>(
        create: (context) => TutorialNavigationBloc(),
        child: BlocBuilder<TutorialNavigationBloc, int>(
          builder: (context, index) {
            return TransformerPageView(
              pageSnapping: true,
              onPageChanged: (index) {
                BlocProvider.of<TutorialNavigationBloc>(context).add(SlideChanged(index: index));
              },
              loop: false,
              transformer: PageTransformerBuilder(
                builder: (Widget child, TransformInfo info) {
                  return Material(
                    color: Theme.of(context).colorScheme.background,
                    elevation: 8.0,
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      alignment: Alignment.center,
                      color: Theme.of(context).colorScheme.background,
                      child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints viewportConstraints) {
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: viewportConstraints.maxHeight
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(height: SizeConfig.getHeight(6)),
                                    ParallaxContainer(
                                      child: BoldText2(text: _headers[info.index], context: context),
                                      position: info.position,
                                      opacityFactor: 0.8,
                                      translationFactor: 400.0,
                                    ),
                                    SizedBox(height: SizeConfig.getHeight(4)),
                                    ParallaxContainer(
                                      child: Image.asset(
                                        _images[info.index],
                                        fit: BoxFit.contain,
                                      ),
                                      position: info.position,
                                      translationFactor: 400.0,
                                    ),
                                    SizedBox(height: SizeConfig.getHeight(3)),
                                    ParallaxContainer(
                                      child: PlatformText(
                                        _body[info.index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onPrimarySubdued,
                                          fontSize: info.index + 1 != _images.length -1 
                                            ? SizeConfig.getWidth(7)  
                                            : SizeConfig.getWidth(4),
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      position: info.position,
                                      translationFactor: 300.0,
                                    ),
                                    SizedBox(height: SizeConfig.getHeight(4)),
                                    ParallaxContainer(
                                      child: Dots(slideIndex: index, numberOfDots: _images.length),
                                      position: info.position,
                                      translationFactor: 500.0,
                                    ),
                                    if (info.index + 1 == _images.length)
                                      SizedBox(height: SizeConfig.getHeight(3)),
                                      ParallaxContainer(
                                        child: FlatButton(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                          onPressed: () => _closeModal(context: context),
                                          child: Text2(text: 'Close', context: context, color: Theme.of(context).colorScheme.callToAction),
                                        ),
                                        position: info.position
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      ),
                    ),
                  );
                } 
              ),
              itemCount: _images.length
            );
          }
        ),
      )
    );
  }
  
  void _closeModal({@required BuildContext context}) {
    Navigator.of(context).pop();
  }
}