import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';
import 'package:weather_now/presentation/bloc/locations/locations_bloc.dart';
import 'package:weather_now/presentation/screens/locations/widget/location_item.dart';
import 'package:flutter/material.dart' hide ReorderableList;
import 'package:weather_now/utils/constants.dart';
import '../../../utils/theme/colors.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final LocationsBloc _bloc = LocationsBloc();
  final List<ItemData> _items = [];
  final isSelectableState = true;
  Map<int, bool> selectedFlag = {};
  bool isSelectionMode = false;


  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return _items.indexWhere((ItemData d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    if (draggingIndex == newPositionIndex) {
      return false; // Agar joylashuv o'zgarmasa, hech narsa o'zgartirilmaydi.
    }

    setState(() {
      // Elementning o'zini almashtiramiz
      final draggedItem = _items.removeAt(draggingIndex);
      _items.insert(newPositionIndex, draggedItem);

      // `isSelected` holatini ham almashtiramiz
      final bool? draggedSelectedState = selectedFlag.remove(draggingIndex);
      selectedFlag[newPositionIndex] = draggedSelectedState!;
    });

    return true;
  }

  void _reorderDone(Key item) {
    final draggedItem = _items[_indexOfKey(item)];
    debugPrint("Reordering finished for ${draggedItem.title}}");
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
      _draggingMode = DraggingMode.iOS;
    });
  }

  void onTap(bool isSelected, int index) {
    if (isSelectionMode) {
      setState(() {
        selectedFlag[index] = !isSelected;
        isSelectionMode = selectedFlag.containsValue(true);
      });
    } else {
      // Tafsilotlar sahifasini ochish
    }
  }


  DraggingMode _draggingMode = DraggingMode.android;


  @override
  void initState() {

    for (int i = 0; i < 19; i++) {
      _items.add(ItemData("title $i", ValueKey("$i"), i));
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
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.black,
            body: ReorderableList(
              onReorder: _reorderCallback,
              onReorderDone: _reorderDone,
              child: CustomScrollView(
                // cacheExtent: 3000,
                slivers: <Widget>[
                  SliverAppBar(
                    actions: <Widget>[
                      PopupMenuButton<DraggingMode>(
                        initialValue: _draggingMode,
                        onSelected: (DraggingMode mode) {
                          setState(() {
                            _draggingMode = mode;
                          });
                        },
                        itemBuilder: (BuildContext context) =>
                        <PopupMenuItem<DraggingMode>>[
                          const PopupMenuItem<DraggingMode>(
                              value: DraggingMode.iOS,
                              child: Text('iOS-like dragging')),
                          const PopupMenuItem<DraggingMode>(
                              value: DraggingMode.android,
                              child: Text('Android-like dragging')),
                        ],
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: const Text("Options"),
                        ),
                      ),
                    ],
                    pinned: true,
                    expandedHeight: 150.0,
                    flexibleSpace: const FlexibleSpaceBar(
                      title: Text('Demo'),
                    ),
                  ),
                  SliverPadding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            bool isSelected = selectedFlag[index] ?? false;

                            return LocationItem(
                              isSelected: isSelected,
                              isCurrent: false,
                              data: _items[index],
                              isFirst: index == 0,
                              isLast: index == _items.length - 1,
                              draggingMode: _draggingMode,
                              onLongPress: () => onLongPress(isSelected, index),
                              onTap: () => onTap(isSelected, index),
                            );
                          },
                          childCount: _items.length,
                        ),
                      )),
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



class ItemData {
  ItemData(this.title, this.key, this.id);

  final String title;

  // Each item in reorderable list needs stable and unique key
  final Key key;
  final int id;
}

enum DraggingMode {
  iOS,
  android,
}