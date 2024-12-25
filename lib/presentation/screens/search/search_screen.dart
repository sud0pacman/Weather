import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart'; // Import the package
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_now/utils/helpers/app_helpers.dart';
import 'package:weather_now/utils/routes/app_routes.dart';
import 'package:weather_now/utils/theme/app_text_styles.dart';

import '../../../components/primary_alert_dialog.dart';
import '../../../components/shape.dart';
import '../../../data/data_source/service/api_call_status.dart';
import '../../../utils/constants.dart';
import '../../../utils/theme/colors.dart';
import '../../bloc/search/search_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late ScrollController _scrollController;
  double _padding = 16.0;
  final GlobalKey _title = GlobalKey();
  double? _titleHeight;

  final SearchBloc _bloc = SearchBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(InitEvent());

    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getWidgetHeight();
    });

    _scrollController.addListener(() {
      double scrollOffset = _scrollController.offset;
      double statusBarHeight = MediaQuery.of(context).padding.top;

      setState(() {
        if (scrollOffset < _titleHeight!) {
          _padding = 16;
        } else if (scrollOffset > statusBarHeight &&
            scrollOffset < statusBarHeight + _titleHeight!) {
          _padding = scrollOffset - _titleHeight! + 16;
        }
      });
    });
  }

  void _getWidgetHeight() {
    final RenderBox renderBox =
        _title.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _titleHeight = renderBox.size.height;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double navigationBarHeight = MediaQuery.of(context).padding.bottom;

    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            body: Container(
              width: AppHelpers.screenWidth(context),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: AppColors.mainBackgroundLinear,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: CustomScrollView(
                controller: _scrollController,
                // Attach the controller to the CustomScrollView
                slivers: [
                  // Non-sticky header (title and description)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: statusBarHeight, left: 24, right: 24),
                      child: Column(
                        key: _title,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Pick Location",
                            style: sfsemiBold.copyWith(fontSize: 24),
                          ),
                          8.verticalSpace,
                          Text(
                            "Choose the area or city that you want to know \nthe detailed weather info at this time.",
                            textAlign: TextAlign.center,
                            style: sfregular.copyWith(
                                fontSize: 12, color: AppColors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverStickyHeader(
                    header: Padding(
                      padding: EdgeInsets.zero,
                      child: Stack(children: [
                        ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: _padding, sigmaY: _padding),
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: _padding,
                                  bottom: 12,
                                  right: 24,
                                  left: 24),
                              child: AppGenericShape(
                                cornerRadius: 20,
                                child: Container(
                                  height: 50,
                                  color: Colors.white.withOpacity(0.1),
                                  child: Center(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 24.0),
                                      child: Theme(
                                        data: ThemeData(
                                          textSelectionTheme: TextSelectionThemeData(
                                            cursorColor: Colors.blue,
                                            selectionHandleColor: Colors.blue,
                                            selectionColor: Colors.blue.withOpacity(.54),
                                          )
                                        ),
                                        child: TextField(
                                          cursorColor: Colors.white,
                                          autocorrect: false,
                                          style: sfregular,
                                          decoration: InputDecoration(
                                            hintText: "Search",
                                            border: InputBorder.none,
                                            hintStyle: sfregular.copyWith(
                                                color: AppColors.tertiaryText),
                                          ),
                                          onChanged: (query) {
                                            if (query.length > 1) {
                                              _bloc.add(SearchingEvent(query));
                                            } else {
                                              _bloc.add(InitEvent());
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (ApiCallStatus.cache == state.status) {
                            return Center(child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Lottie.asset(Constants.internetLottie),
                            ));
                          }

                          if (state.isLoading == false && state.weathers.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "No results found",
                                    style: sfregular.copyWith(
                                      fontSize: 14
                                    ),
                                  ),
                                )
                              ],
                            );
                          }

                          if (index == 0) {
                            return 12.verticalSpace;
                          } else {
                            final location = state.weathers[index - 1];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 6),
                              child: GestureDetector(
                                onTap: () {

                                  if (location.isSaved == false) {
                                    _bloc.add(AddFavouriteEvent(location));
                                  }


                                  Get.offNamed(AppRoutes.home, arguments: {
                                    'location': "${location.lat},${location.lon}"
                                  });

                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AppGenericShape(
                                        cornerRadius: 25,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.2),
                                                blurRadius: 10,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16.0,
                                                horizontal: 24.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    location.name.toString(),
                                                    overflow: TextOverflow.ellipsis,
                                                    style: sfregular.copyWith(
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                if (location.isSaved == false)
                                                  const Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (location.isSaved) 8.horizontalSpace,
                                    if (location.isSaved)
                                      AppGenericShape(
                                        cornerRadius: 20,
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.1),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              showAlertDialog(context, onTapOk: () {
                                                Get.back();
                                                _bloc.add(DeleteFavouriteEvent(index-1));
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        childCount: state.weathers.length + 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  void showAlertDialog(BuildContext context, {required VoidCallback onTapOk}) {
    showDialog(
      context: context,
      builder: (context) => PrimaryAlertDialog(
        title: "Warning",
        content: "Are you sure you want to delete ?",
        onTapOk: onTapOk,
      ),
    );
  }

}