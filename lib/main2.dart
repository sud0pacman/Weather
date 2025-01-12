import 'package:flutter/material.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart' as custom_reorderable_list;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_now/utils/theme/app_styles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Location> staticData = MyData.data;
  Map<int, bool> selectedFlag = {};
  bool isSelectionMode = false;

  // Returns index of item with given key
  int _indexOfKey(Key key) {
    return staticData.indexWhere((Location d) => d.key == key);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    if (draggingIndex == newPositionIndex) {
      return false; // No change in position
    }

    setState(() {
      // Swap the items in the list
      final draggedItem = staticData.removeAt(draggingIndex);
      staticData.insert(newPositionIndex, draggedItem);

      // Swap the selected states
      bool draggedSelectedState = selectedFlag[draggingIndex] ?? false;
      bool newPositionSelectedState = selectedFlag[newPositionIndex] ?? false;

      // Swap the selection state
      selectedFlag[draggingIndex] = newPositionSelectedState;
      selectedFlag[newPositionIndex] = draggedSelectedState;

      // Cleanup false selections
      if (!selectedFlag[draggingIndex]!) {
        selectedFlag.remove(draggingIndex);
      }
      if (!selectedFlag[newPositionIndex]!) {
        selectedFlag.remove(newPositionIndex);
      }
    });

    return true;
  }


  Widget _buildItem(
      BuildContext context, {
        required int index,
        required bool isSelected,
        required Location data,
        required custom_reorderable_list.ReorderableItemState state,
        VoidCallback? onLongPress,
        VoidCallback? onTap,
      }) {
    BoxDecoration decoration;

    // Dragging va placeholder dekoratsiyasini boshqarish
    if (state == custom_reorderable_list.ReorderableItemState.placeholder) {
      decoration = const BoxDecoration();
    } else {
      bool dragging = state == custom_reorderable_list.ReorderableItemState.dragProxy || state == custom_reorderable_list.ReorderableItemState.dragProxyFinished;

      decoration = BoxDecoration(
        border: Border(
          top: isFirst(index)
              ? Divider.createBorderSide(context)
              : BorderSide.none,
          bottom: isLast(index)
              ? Divider.createBorderSide(context)
              : BorderSide.none,
        ),
        color: dragging ? Colors.grey.withOpacity(0.1) : Theme.of(context).canvasColor,
      );
    }

    return Container(
      decoration: decoration,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Opacity(
          opacity: state == custom_reorderable_list.ReorderableItemState.placeholder
              ? 0.0
              : 1.0,
          child: IntrinsicHeight(
            child: _itemContent(
              isSelected: isSelected,
              data: data,
              onLongPress: onLongPress,
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }

  void onLongPress(bool isSelected, int index) {
    setState(() {
      selectedFlag[index] = !isSelected;
      isSelectionMode = selectedFlag.containsValue(true);
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Item'),
      ),
      body: custom_reorderable_list.ReorderableList(
        onReorder: _reorderCallback,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    Location data = staticData[index];
                    selectedFlag[index] = selectedFlag[index] ?? false;
                    bool isSelected = selectedFlag[index]!;
                    return custom_reorderable_list.ReorderableItem(
                      key: data.key,
                      childBuilder: (BuildContext context, custom_reorderable_list.ReorderableItemState state) {
                        return _buildItem(
                          context,
                          index: index,
                          isSelected: isSelected,
                          data: data,
                          state: state,
                          onLongPress: () => onLongPress(isSelected, index),
                          onTap: () => onTap(isSelected, index),
                        );
                      },
                    );
                  },
                  childCount: staticData.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isFirst(int index) => index == 0;

  bool isLast(int index) => index == staticData.length - 1;

  Widget _itemContent(
      {required bool isSelected,
        required Location data,
        VoidCallback? onLongPress,
        VoidCallback? onTap}) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          _buildSelectIcon(isSelected, data),
          const SizedBox(width: 16,),
          Expanded(
              child: InkWell(
                  onLongPress: onLongPress,
                  onTap: onTap,
                  child: Text(
                    data.name,
                    style: AppStyles.bodyRegularL,
                  ))),
          !isSelectionMode
              ? Container()
              : const Handle(child: SizedBox(height: 56, width: 56, child: Icon(Icons.drag_handle))),
        ],
      ),
    );
  }

  Widget _buildSelectIcon(bool isSelected, Location data) {
    if (isSelectionMode) {
      return Icon(
        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
        color: Theme.of(context).primaryColor,
      );
    } else {
      return CircleAvatar(
        child: Text('${data.id}'),
      );
    }
  }

}

class Handle extends StatelessWidget {
  final Widget child;
  const Handle({required this.child});
  @override
  Widget build(BuildContext context) {
    return custom_reorderable_list.ReorderableListener(
      child: child,
    );
  }
}

class MyData {
  static List<Location> data = [
    Location(id: 1, name: "Bir", email: "mailward0@hibu.com", address: "57 Bowman Drive"),
    Location(id: 2, name: "Ikki", email: "mviveash1@sohu.com", address: "2171 Welch Avenue"),
    Location(id: 3, name: "Uch", email: "mdonaghy2@dell.com", address: "4623 Chinook Circle"),
    Location(id: 4, name: "To'rt", email: "mkilfoyle3@yahoo.co.jp", address: "406 Kings Road"),
    Location(id: 5, name: "Besh", email: "wvenn4@baidu.com", address: "2444 Pawling Lane"),
  ];
}

class Location {
  final int id;
  final String name;
  final String email;
  final String address;
  final Key key;

  Location({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
  }) : key = ValueKey(id);

  @override
  String toString() {
    return 'Location{id: $id, name: $name, email: $email, address: $address}';
  }
}
