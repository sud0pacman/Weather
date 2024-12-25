import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_now/presentation/bloc/locations/locations_bloc.dart';
import 'package:weather_now/presentation/screens/locations/widget/location_item.dart';
import 'package:weather_now/utils/helpers/app_helpers.dart';

import '../../../utils/theme/colors.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final LocationsBloc _bloc = LocationsBloc();

  @override
  void initState() {
    _bloc.add(LocationInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<LocationsBloc, LocationsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              height: AppHelpers.screenHight(context),
              width: AppHelpers.screenWidth(context),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: AppColors.mainBackgroundLinear,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter
                ),
              ),
              child: Stack(
                children: [
                  topRightSection(),

                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        56.verticalSpace,
                        if (state.isLoading != true) ListView.separated(
                          itemCount: 20,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, ind) => const LocationItem(isCurrent: true,),
                          separatorBuilder: (ctx, ind) => 14.verticalSpace,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget topRightSection() {
    return Positioned(
      top: -100,
      right: -100,
      child: Stack(
        children: [
          Container(
            width: 250,
            height: 250,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.topLeft,
                colors: AppColors.subBackgroundLinear,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
