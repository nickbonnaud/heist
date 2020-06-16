import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/resources/helpers/loading_widget.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';

import 'bottom_modal_app_bar.dart';

class SearchBusinessNameModal extends StatelessWidget {
  final FocusNode _businessNameNode = FocusNode();
  final BusinessRepository _businessRepository = BusinessRepository();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: BottomModalAppBar(backgroundColor: Colors.grey.shade100),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            PlatformWidget(
              android: (_) => TypeAheadFormField(
                loadingBuilder: (BuildContext context) => Center(
                  child: LoadingWidget(),
                ),
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  color: Colors.grey.shade100,
                  elevation: 0
                ),
                debounceDuration: Duration(milliseconds: 500),
                textFieldConfiguration: TextFieldConfiguration(
                  focusNode: _businessNameNode,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.getWidth(7),
                  ),
                  decoration: InputDecoration(
                    hintText: "Business Name",
                    hintStyle: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.getWidth(7)
                    ),
                  ),
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => Navigator.of(context).pop()
                ),
                suggestionsCallback: _suggestionCallback, 
                itemBuilder: (context, Business business) {
                  return _buildSuggestion(business);
                }, 
                onSuggestionSelected: (Business business) {
                  Navigator.of(context).pop(business);
                },
                hideSuggestionsOnKeyboardHide: false,
              ),
              ios: (_) => CupertinoTypeAheadFormField(
                loadingBuilder: (BuildContext context) => Center(
                  child: LoadingWidget(),
                ),
                suggestionsBoxDecoration: CupertinoSuggestionsBoxDecoration(
                  color: Colors.grey.shade100,
                ),
                debounceDuration: Duration(milliseconds: 500),
                textFieldConfiguration: CupertinoTextFieldConfiguration(
                  focusNode: _businessNameNode,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w700,
                    fontSize: SizeConfig.getWidth(7)
                  ),
                  placeholder: "Business Name",
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  autofocus: true,
                  onSubmitted: (_) => Navigator.of(context).pop()
                ),
                suggestionsCallback: _suggestionCallback,
                itemBuilder: (context, Business business) {
                  return _buildSuggestion(business);
                },
                onSuggestionSelected: (Business business) {
                  Navigator.of(context).pop(business);
                },
                hideSuggestionsOnKeyboardHide: false,
              ),
            )
          ],
        ),
      ) 
    );
  }

  Future<List<Business>> _suggestionCallback(String pattern) async {
    return await _businessRepository.fetchByName(name: pattern);
  }

  Widget _buildSuggestion(Business business) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(business.photos.logo.smallUrl),
            radius: SizeConfig.getWidth(8),
          ),
          title: BoldText(text: business.profile.name, size: SizeConfig.getWidth(5), color: Colors.black),
        ),
      )
    );
  }
}