import 'package:Happinest/common/common_imports/common_imports.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<dynamic> listType;
  final Function(
    String selectValue,
  ) onSelect;
  final String? selectedText;

  const CustomBottomSheet(
      {super.key,
      required this.listType,
      required this.onSelect,
      this.selectedText});

  @override
  Widget build(BuildContext context) {
    return TCard(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15)),
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    onSelect(listType[index]);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: TText(listType[index],
                        color: selectedText != null &&
                                selectedText == listType[index]
                            ? TAppColors.themeColor
                            : TAppColors.black,
                        fontWeight: FontWeightManager.regular),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Utility.addDivider();
              },
              itemCount: listType.length)),
    );
  }
}

abstract class ToolsEnum<T> {
  T getEnumFromString(String value);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
