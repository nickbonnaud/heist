import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/global_widgets/cached_avatar.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/default_app_bar.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/transaction_picker_screen/models/transaction_picker_args.dart';
import 'package:heist/themes/global_colors.dart';

class TransactionBusinessPickerScreen extends StatelessWidget {
  final List<Business> _availableBusinesses;

  const TransactionBusinessPickerScreen({required List<Business> availableBusinesses})
    : _availableBusinesses = availableBusinesses;
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DefaultAppBarBloc>(
      create: (_) => DefaultAppBarBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.scrollBackground,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                DefaultAppBar(
                  backgroundColor: Theme.of(context).colorScheme.scrollBackground,
                  isSliver: true,
                  title: "Select Business",
                ),
                SliverPadding(
                  padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 20.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _businessTile(
                        context: context,
                        business: _availableBusinesses[index],
                        key: "businessCardKey-$index"
                      ),
                      childCount: _availableBusinesses.length
                    )
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _businessTile({required BuildContext context, required Business business, required String key}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.w),
      child: Card(
        child: ListTile(
          key: Key(key),
          leading: CachedAvatar(
            url: business.photos.logo.smallUrl,
            radius: 30.w,
          ),
          title: Text(
            business.profile.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp
            ),
          ),
          subtitle: Text(
            "Claim your transaction for ${business.profile.name}."
          ),
          onTap: () => _goToTransactionPicker(context: context, business: business),
        ),
      ),
    );
  }

  void _goToTransactionPicker({required BuildContext context, required Business business}) {
    Navigator.of(context).pushNamed(Routes.transactionPicker, arguments: TransactionPickerArgs(business: business, fromSettings: true));
  }
}