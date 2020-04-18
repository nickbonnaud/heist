import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/models/date_range.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
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
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: SizeConfig.getWidth(7),
                        decoration: state.active == Active.start ? TextDecoration.underline : null
                      ),
                    );
                  }
                )
              ),
              SizedBox(height: SizeConfig.getHeight(3)),
              BoldText(text: "To", size: SizeConfig.getWidth(7), color: Colors.black),
              SizedBox(height: SizeConfig.getHeight(3)),
              GestureDetector(
                onTap: () => BlocProvider.of<IosDatePickerBloc>(context).add(ActiveSelectionChanged(active: Active.end)),
                child: BlocBuilder<IosDatePickerBloc, IosDatePickerState>(
                  builder: (context, state) {
                    return Text(
                      _formatDate(state.endDate),
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
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
                color: Colors.white,
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
                              )
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
                              )
                            ),
                            onPressed: () => BlocProvider.of<IosDatePickerBloc>(context).add(ActiveSelectionChanged(active: Active.start)),
                          );
                        }
                      },
                    ),
                    BlocBuilder<IosDatePickerBloc, IosDatePickerState>(
                      builder: (context, state) {
                        return CupertinoButton(
                          child: BoldText(text: 'Submit', size: SizeConfig.getWidth(5), color: state.startDate != null && state.endDate != null
                          ? Colors.black : Colors.black12),
                          onPressed: () => state.startDate != null && state.endDate != null && state.startDate.isBefore(state.endDate)
                            ? Navigator.of(context).pop(DateRange(startDate: state.startDate, endDate: state.endDate)) : null
                        );
                      },
                    )
                  ],
                ),
              ),
              Container(
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