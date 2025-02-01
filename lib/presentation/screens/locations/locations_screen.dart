import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as reorderable;
import 'package:weather_now/presentation/bloc/locations/locations_bloc.dart';
import 'package:weather_now/presentation/screens/locations/widget/location_item.dart';
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:weather_now/presentation/screens/locations/widget/one_ui_nested_scroll_view.dart';
import 'package:weather_now/utils/constants.dart';
import '../../../utils/theme/app_styles.dart';
import '../../../utils/theme/colors.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final LocationsBloc _bloc = LocationsBloc();
  final isSelectableState = true;
  String unSelectedTitle = "Manage locations";
  String selectedTitle = "";
  Map<int, bool> selectedFlag = {};

  bool isSelectionMode = false;

  int _indexOfKey(Key key) {
    // return _items.indexWhere((ItemData d) => d.key == key);
    return 0;
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    if (draggingIndex == newPositionIndex) {
      return false; // No change in position
    }

    // setState(() {
    //   // Swap the items in the list
    //   final draggedItem = _items.removeAt(draggingIndex);
    //   _items.insert(newPositionIndex, draggedItem);
    //
    //   // Swap the selected states
    //   bool draggedSelectedState = selectedFlag[draggingIndex] ?? false;
    //   bool newPositionSelectedState = selectedFlag[newPositionIndex] ?? false;
    //
    //   // Swap the selection state
    //   selectedFlag[draggingIndex] = newPositionSelectedState;
    //   selectedFlag[newPositionIndex] = draggedSelectedState;
    //
    //   // Cleanup false selections
    //   if (!selectedFlag[draggingIndex]!) {
    //     selectedFlag.remove(draggingIndex);
    //   }
    //   if (!selectedFlag[newPositionIndex]!) {
    //     selectedFlag.remove(newPositionIndex);
    //   }
    // });

    return true;
  }


  void _reorderDone(Key item) {
    // final draggedItem = _items[_indexOfKey(item)];
    // debugPrint("Reordering finished for ${draggedItem.title}}");
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);

      int selectedItemLen = selectedItemLength();
      _draggingMode = getDraggingMode(selectedItemLen);
      selectedTitle = "$selectedItemLen selected";
    });
  }

  void onTap(bool isSelected, int index) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);

        int selectedItemLen = selectedItemLength();
        _draggingMode = getDraggingMode(selectedItemLen);
        selectedTitle = "$selectedItemLen selected";
      });
    } else {
      // Open details page
    }
  }

  void selectAll(bool isSelected) {
    setState(() {
      // for (int i = 0; i < _items.length; i++) {
      //   selectedFlag[i] = isSelected;
      // }
      // isSelectionMode = isSelected;
      // int selectedItemLen = selectedItemLength();
      // _draggingMode = getDraggingMode(selectedItemLen);
      // selectedTitle = "$selectedItemLen selected";
    });
  }

  final List<Widget> unselectedActions = [
    const SizedBox(
      width: 16,
    ),
    IconButton(
      onPressed: () {},
      padding: const EdgeInsets.all(0),
      constraints: const BoxConstraints(),
      icon: const Icon(
        CupertinoIcons.ellipsis_vertical,
        color: AppColors.white,
        size: 20,
      ),
      style: const ButtonStyle(
        padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(0)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
    const SizedBox(
      width: 12,
    ),
    IconButton(
      onPressed: () {},
      padding: const EdgeInsets.all(0),
      constraints: const BoxConstraints(),
      icon: const Icon(
        CupertinoIcons.search,
        color: AppColors.white,
        size: 22,
      ),
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.all(0)), // Remove default padding
      ),
    ),
  ];

  final List<Widget> selectedActions = [];

  Widget unSelectedLeading() {
    return IconButton(
        onPressed: () {},
        icon: const Icon(CupertinoIcons.chevron_left, color: AppColors.white, size: 24,)
    );
  }

  Widget selectedLeading() {
    // bool allSelected = selectedItemLength() == _items.length;
    bool allSelected = false;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => selectAll(!allSelected),
          icon: Icon(
            allSelected ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
            color: allSelected ? Colors.blueAccent : Colors.grey,
          ),
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(0)),
          ),
        ),
        Text(
          "All",
          style: AppStyles.bodyRegularS.copyWith(
            color: AppColors.white,
            fontSize: 12,
            height: .1,
          ),
        ),
      ],
    );
  }

  DraggingMode _draggingMode = DraggingMode.android;

  @override
  void initState() {
    for (int i = 0; i < 4; i++) {
      // _items.add(ItemData("title $i", ValueKey("$i"), i));
    }

    _bloc.add(LocationInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<LocationsBloc, LocationsState>(
        listener: (context, state) {
          Constants.logger.i(state);
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.black,
            body: reorderable.ReorderableList(
              onReorder: _reorderCallback,
              onReorderDone: _reorderDone,
              child: OneUiNestedScrollView(
                  toolbarHeight: 80,
                  expandedWidget: Text(
                    _draggingMode == DraggingMode.android ? unSelectedTitle : selectedTitle,
                    style: AppStyles.bodyRegularXL.copyWith(fontSize: 35, color: AppColors.white),
                  ),
                  collapsedWidget: Text(
                    _draggingMode == DraggingMode.android ? unSelectedTitle : selectedTitle,
                    style: AppStyles.bodySemiBoldM.copyWith(fontSize: 20, color: AppColors.white),
                  ),
                  leadingIcon: _draggingMode == DraggingMode.android ? unSelectedLeading() : selectedLeading(),
                  boxDecoration: const BoxDecoration(
                      color: AppColors.black
                  ),
                  actions: _draggingMode == DraggingMode.android ? unselectedActions : selectedActions,

                  sliverBackgroundColor: AppColors.black,
                  body: SliverPadding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                          childCount: state.savedLocations.length,
                              (context, index) {
                            var entry = state.savedLocations.entries.toList()[index];
                            Constants.logger.i("${entry.key} => ${entry.value.location.name}");
                            bool isSelected = selectedFlag[entry.key] ?? false;

                            var data = entry.value;

                            // return Text("${data.key}, ${data.location.country}, ${data.current.tempC}, ${data.forecast.forecastday[0].day.maxTempC}, ${data.forecast.forecastday[0].day.minTempC}");
                            return LocationItem(
                              isSelected: isSelected,
                              isCurrent: false,
                              data: data,
                              isSelectionMode: _draggingMode == DraggingMode.iOS,
                              isFirst: index == 0,
                              isLast: index == state.savedLocations.length - 1,
                              draggingMode: _draggingMode,
                              onLongPress: () => onLongPress(isSelected, entry.key),
                              onTap: () => onTap(isSelected, entry.key),
                            );
                          }
                      )
                    ),
                  )
              ),
            ),
          );
        },
      ),
    );
  }

  int selectedItemLength() {
    return selectedFlag.values.where((e) => e == true).length;
  }

  DraggingMode getDraggingMode(int length) => length == 0 ? DraggingMode.android : DraggingMode.iOS;
}

class ItemData {
  ItemData(this.title, this.key, this.id);

  final String title;
  final Key key;
  final int id;
}

enum DraggingMode {
  iOS,
  android,
}
