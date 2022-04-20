import 'package:flutter/material.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorCard extends StatelessWidget {
  final String _body;
  final String? _buttonText;
  final VoidCallback? _onButtonPressed;

  const ErrorCard({required String body, String? buttonText, VoidCallback? onButtonPressed, Key? key})
    : _body = body,
      _buttonText = buttonText,
      _onButtonPressed = onButtonPressed,
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 20.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1.0,
            blurRadius: 5,
            offset: Offset(0, -5.h)
          )
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 18.h),
              Text(
                "Malfunction!",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30.sp
                ),
              ),
              SizedBox(height: 40.h),
              Text(
                _body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold
                ),
              )
            ],
          ),
          _onButtonPressed != null
            ? Row(
                children: [
                  SizedBox(width: .1.sw),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _onButtonPressed,
                      child: ButtonText(text: _buttonText!)
                    )
                  ),
                  SizedBox(width: .1.sw),
                ],
              )
            : Container()
        ],
      ),
    );
  }
}