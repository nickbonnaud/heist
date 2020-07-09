import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/models/date_range.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:intl/intl.dart';

import 'bloc/ios_date_picker_bloc.dart';

class IosDatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BottomModalAppBar(backgroundColor: Colors.grey.shade300.withOpacity(.90)),
      backgroundColor: Colors.grey.shade300.withOpacity(.90),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height: SizeConfig.getHeight(20)),
              GestureDetector(
                onTap: () => BlocProvider.of<IosDatePickerBloc>(context).add(ActiveSelectionChanged(active: Active.start)),
                child: BlocBuilder<IosDatePickerBloc, IosDatePickerState>(
                  builder: (context, state) {
                    return Text(
                      state.startDate != null ? _formatDate(state.startDate) : "Select Start Date",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.textOnLight,
                        fontSize: SizeConfig.getWidth(7),
                        decoration: state.active == Active.start ? TextDecoration.underline : null
                      ),
                    );
                  }
                )
              ),
              SizedBox(height: SizeConfig.getHeight(3)),
              BoldText2(text: "To", context: context),
              SizedBox(height: SizeConfig.getHeight(3)),
              GestureDetector(
                onTap: () => BlocProvider.of<IosDatePickerBloc>(context).add(ActiveSelectionChanged(active: Active.end)),
                child: BlocBuilder<IosDatePickerBloc, IosDatePickerState>(
                  builder: (context, state) {
                    return Text(
                      _formatDate(state.endDate),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.textOnLight,
                        fontSize: SizeConfig.getWidth(7),
                        decoration: state.active == Active.end ? TextDecoration.underline : null
                      ),
                    );
                  }
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                color: Theme.of(context).colorScheme.background,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    BlocBuilder<IosDatePickerBloc, IosDatePickerState>(
                      builder: (context, state) {
                        if (state.active == Active.start) {
                          return CupertinoButton(
                            child: Icon(
                              IconData(
                                0xF3D0,
                                fontFamily: CupertinoIcons.iconFont,
                                fontPackage: CupertinoIcons.iconFontPackage
                              ),
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: () => BlocProvider.of<IosDatePickerBloc>(context).add(ActiveSelectionChanged(active: Active.end)),
                          );
                        } else {
                          return CupertinoButton(
                            child: Icon(
                              IconData(
                                0xF3D8,
                                fontFamily: CupertinoIcons.iconFont,
                                fontPackage: CupertinoIcons.iconFontPackage
                              ),
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: () => BlocProvider.of<IosDatePickerBloc>(context).add(ActiveSelectionChanged(active: Active.start)),
                          );
                        }
                      },
                    ),
                    BlocBuilder<IosDatePickerBloc, IosDatePickerState>(
                      builder: (context, state) {
                        return FlatButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                          child: BoldText4(
                            text: 'Submit', 
                            context: context, 
                            color: state.startDate != null && state.endDate != null
                              ? Theme.of(context).colorScheme.primary 
                              : Theme.of(context).colorScheme.primarySubdued
                          ),
                          onPressed: () => state.startDate != null && state.endDate != null && state.startDate.isBefore(state.endDate)
                            ? Navigator.of(context).pop(DateRange(startDate: state.startDate, endDate: state.endDate)) : null
                        );
                      },
                    )
                  ],
                ),
              ),
              Container(
                color: Theme.of(context).colorScheme.background,
                height: SizeConfig.getHeight(20),
                child: BlocBuilder<IosDatePickerBloc, IosDatePickerState>(
                  builder: (context, state) {
                    return CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: state.active == Active.end ? DateTime.now() : state.endDate,
                      maximumDate: state.active == Active.end ? DateTime.now() : state.endDate,
                      onDateTimeChanged: (DateTime selectedDate) => BlocProvider.of<IosDatePickerBloc>(context).add(DateChanged(date: selectedDate))
                    );
                  },
                ) 
              )
            ],
          )
        ],
      )
    );
  }

  String _formatDate(DateTime date) {
    DateFormat formatter = DateFormat('MMMM d y');
    return formatter.format(date);
  }
}