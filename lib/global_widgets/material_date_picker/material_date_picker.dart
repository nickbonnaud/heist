import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/global_widgets/bottom_modal_app_bar.dart';
import 'package:heist/global_widgets/material_date_picker/bloc/material_date_picker_bloc.dart';
import 'package:heist/models/date_range.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:intl/intl.dart';

class MaterialDatePicker extends StatefulWidget {
  @override
  State<MaterialDatePicker> createState() => _MaterialDatePicker();
}

class _MaterialDatePicker extends State<MaterialDatePicker> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _showDatePicker(active: Active.start, context: context); 
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BottomModalAppBar(backgroundColor: Colors.grey.shade300.withOpacity(.90)),
      backgroundColor: Colors.grey.shade300.withOpacity(.90),
      body: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: SizeConfig.getHeight(25)),
                  BlocBuilder<MaterialDatePickerBloc, MaterialDatePickerState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () => _showDatePicker(
                          active: Active.start,
                          context: context,
                          state: state
                        ),
                        child: Text(
                          state.startDate != null ? _formatDate(state.startDate) : "Select Start Date",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: SizeConfig.getWidth(7),
                            decoration: state.active == Active.start ? TextDecoration.underline : null
                          ),
                        )
                      );
                    },
                  ),
                  SizedBox(height: SizeConfig.getHeight(3)),
                  BoldText(text: "To", size: SizeConfig.getWidth(7), color: Colors.black),
                  SizedBox(height: SizeConfig.getHeight(3)),
                  BlocBuilder<MaterialDatePickerBloc, MaterialDatePickerState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () => _showDatePicker(
                          active: Active.end,
                          context: context,
                          state: state
                        ),
                        child: Text(
                          _formatDate(state.endDate),
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: SizeConfig.getWidth(7),
                            decoration: state.active == Active.end ? TextDecoration.underline : null
                          ),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: OutlineButton(
                      borderSide: BorderSide(
                        color: Colors.black
                      ),
                      disabledBorderColor: Colors.grey.shade500,
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      onPressed: () => Navigator.of(context).pop(),
                      child: BoldText(text: 'Cancel', size: SizeConfig.getWidth(6), color: Colors.black),
                    )
                  ),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: BlocBuilder<MaterialDatePickerBloc, MaterialDatePickerState>(
                      builder: (context, state) {
                        return RaisedButton(
                          color: Colors.green,
                          disabledColor: Colors.green.shade100,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          onPressed: state.startDate != null && state.endDate != null && state.startDate.isBefore(state.endDate)
                            ? () => Navigator.of(context).pop(DateRange(startDate: state.startDate, endDate: state.endDate))
                            : null,
                          child: BoldText(text: 'Submit', size: SizeConfig.getWidth(6), color: Colors.white)
                        );
                      }
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ) 
    );
  }

  String _formatDate(DateTime date) {
    DateFormat formatter = DateFormat('MMMM d y');
    return formatter.format(date);
  }

  void _showDatePicker({@required Active active, @required BuildContext context, MaterialDatePickerState state}) async {
    BlocProvider.of<MaterialDatePickerBloc>(context).add(ActiveSelectionChanged(active: active));
    DateTime date = await showDatePicker(
      context: context,
      initialDate: state == null || active == Active.end ? DateTime.now() : state.endDate,
      firstDate: DateTime(2015), 
      lastDate: state == null || active == Active.end ? DateTime.now() : state.endDate,
    );
    BlocProvider.of<MaterialDatePickerBloc>(context).add(DateChanged(date: date));
  }
}