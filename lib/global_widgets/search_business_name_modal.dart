import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:heist/global_widgets/cached_avatar.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/global_widgets/loading_widget.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/themes/global_colors.dart';

import 'bottom_modal_app_bar.dart';

class SearchBusinessNameModal extends StatefulWidget {
  final BusinessRepository _businessRepository;

  SearchBusinessNameModal({required BusinessRepository businessRepository})
    : _businessRepository = businessRepository;
  
  @override
  State<SearchBusinessNameModal> createState() => _SearchBusinessNameModalState();
}

class _SearchBusinessNameModalState extends State<SearchBusinessNameModal> {
  final FocusNode _businessNameNode = FocusNode();
  late TextEditingController _businessNameController;

  @override
  void initState() {
    super.initState();
    _businessNameController = TextEditingController();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: BottomModalAppBar(context: context, backgroundColor: Theme.of(context).colorScheme.scrollBackground),
      backgroundColor: Theme.of(context).colorScheme.scrollBackground,
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _textField()
          ],
        ),
      ) 
    );
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessNameNode.dispose();
    super.dispose();
  }

  Widget _textField() {
    return TypeAheadFormField(
      loadingBuilder: (BuildContext context) => Center(
        child: CircularProgressIndicator(color: Colors.red),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: Theme.of(context).colorScheme.scrollBackground,
        elevation: 0
      ),
      debounceDuration: Duration(milliseconds: 500),
      textFieldConfiguration: TextFieldConfiguration(
        controller: _businessNameController,
        focusNode: _businessNameNode,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: SizeConfig.getWidth(7),
        ),
        decoration: InputDecoration(
          hintText: "Business Name",
          hintStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.getWidth(7),
            color: Theme.of(context).colorScheme.onPrimaryDisabled
          ),
        ),
        cursorColor: Theme.of(context).colorScheme.callToAction,
        autocorrect: false,
        autofocus: true,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => Navigator.of(context).pop()
      ),
      suggestionsCallback: _suggestionCallback, 
      itemBuilder: (context, Business business) {
        return _buildSuggestion(context: context, business: business);
      },
      // noItemsFoundBuilder: (BuildContext context) {
      //   if (_businessNameController.text.isNotEmpty) {
      //     return Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text2(text: "No Businesses Found!", context: context)
      //       ],
      //     );
      //   }
      //   return Container();
      // },
      onSuggestionSelected: (Business business) {
        Navigator.of(context).pop(business);
      },
      hideSuggestionsOnKeyboardHide: false,
    );
  }
  
  Future<List<Business>> _suggestionCallback(String pattern) async {
    final PaginateDataHolder holder = await widget._businessRepository.fetchByName(name: pattern);
    return holder.data as List<Business>;
  }

  Widget _buildSuggestion({required BuildContext context, required Business business}) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: CachedAvatar(
            url: business.photos.logo.smallUrl, 
            radius: 8
          ),
          title: BoldText4(text: business.profile.name, context: context),
        ),
      )
    );
  }
}