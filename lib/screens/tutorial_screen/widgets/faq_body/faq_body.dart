import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/faq_body_bloc.dart';

class FaqBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaqBodyBloc, FaqBodyState>(
      builder: (context, state) {
        return ListView.separated(
          key: Key("faqBodyKey"),
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.faqs.length,
          separatorBuilder: (_, __) => SizedBox(height: SizeConfig.getHeight(3)),
          padding: EdgeInsets.symmetric(horizontal: 8),
          itemBuilder: (BuildContext context, int index) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    key: Key("faqQuestionKey-$index"),
                    child: PlatformText(
                      "Q: ${state.faqs[index].question}" ,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.callToAction,
                        fontSize: SizeConfig.getWidth(6),
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () => BlocProvider.of<FaqBodyBloc>(context).add(ToggleAnswerVisibility(faq: state.faqs[index])),
                  ),
                  SizedBox(height: SizeConfig.getHeight(1)),
                  Visibility(
                    visible: state.faqs[index].answerVisible,
                    child: GestureDetector(
                      key: Key("faqAnswerKey-$index"),
                      child: PlatformText(
                        "A: ${state.faqs[index].answer}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimarySubdued,
                          fontSize: SizeConfig.getWidth(6),
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onTap: () => BlocProvider.of<FaqBodyBloc>(context).add(ToggleAnswerVisibility(faq: state.faqs[index])),
                    )
                  )
                ],
              );
          }
        );
      }
    );
  }
}