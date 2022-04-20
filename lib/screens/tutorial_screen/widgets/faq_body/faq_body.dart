import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bloc/faq_body_bloc.dart';

class FaqBody extends StatelessWidget {
  
  const FaqBody({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaqBodyBloc, FaqBodyState>(
      builder: (context, state) {
        return ListView.separated(
          key: const Key("faqBodyKey"),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: state.faqs.length,
          separatorBuilder: (_, __) => SizedBox(height: 24.h),
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          itemBuilder: (BuildContext context, int index) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    key: Key("faqQuestionKey-$index"),
                    child: Text(
                      "Q: ${state.faqs[index].question}" ,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.callToAction,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    onTap: () => BlocProvider.of<FaqBodyBloc>(context).add(ToggleAnswerVisibility(faq: state.faqs[index])),
                  ),
                  SizedBox(height: 10.h),
                  Visibility(
                    visible: state.faqs[index].answerVisible,
                    child: GestureDetector(
                      key: Key("faqAnswerKey-$index"),
                      child: Text(
                        "A: ${state.faqs[index].answer}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimarySubdued,
                          fontSize: 22.sp,
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