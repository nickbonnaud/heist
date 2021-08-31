import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/cached_avatar.dart';
import 'package:heist/global_widgets/search_business_name_modal/bloc/search_business_name_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBusinessNameBody extends StatefulWidget {

  @override
  State<SearchBusinessNameBody> createState() => _SearchBusinessNameBodyState();
}

class _SearchBusinessNameBodyState extends State<SearchBusinessNameBody> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        key: Key("searchBusinessNameBodyKey"),
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          _textField(),
          SizedBox(height: 25.h),
          _body()
        ],
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _textField() {
    return TextField(
      key: Key("businessNameFieldKey"),
      focusNode: _focusNode,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 28.sp,
      ),
      decoration: InputDecoration(
        hintText: "Business Name",
        hintStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 28.sp,
          color: Theme.of(context).colorScheme.onPrimaryDisabled
        ),
      ),
      autocorrect: false,
      autofocus: true,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _focusNode.unfocus(),
      onChanged: _onBusinessNameChanged,
    );
  }

  Widget _body() {
    return BlocBuilder<SearchBusinessNameBloc, SearchBusinessNameState>(
      builder: (context, state) {
        
        if (state.isSubmitting) return CircularProgressIndicator();

        if (state.errorMessage.isNotEmpty) return Center(key: Key("errorSearchBusinessNameKey"), child: Text(state.errorMessage, style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold, fontSize: 28.sp)));

        if (state.businesses == null) return Container();

        if (state.businesses!.isEmpty) return Center(child: Text("No Businesses Found!", style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold, fontSize: 28.sp)));

        return _businessList(businesses: state.businesses!);
      }
    );
  }

  Widget _businessList({required List<Business> businesses}) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: businesses.length,
        itemBuilder: (context, index) {
          return Card(
            key: Key("businessNameCardKey-$index"),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: ListTile(
                onTap: () => Navigator.of(context).pop(businesses[index]),
                leading: CachedAvatar(
                  url: businesses[index].photos.logo.smallUrl, 
                  radius: 40.w
                ),
                title: Text(
                  businesses[index].profile.name,
                  style: TextStyle(
                    fontSize: 22.sp
                  ),
                )
              ),
            )
          );
        }
      ),
    );
  }
  
  void _onBusinessNameChanged(String name) {
    BlocProvider.of<SearchBusinessNameBloc>(context).add(BusinessNameChanged(name: name));
  }
}