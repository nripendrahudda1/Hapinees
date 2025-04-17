
import 'package:Happinest/common/common_imports/common_imports.dart';
class TBACKButton extends StatelessWidget {
  const TBACKButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding.top;
    return Padding(
      padding: EdgeInsets.only(top: padding == 0.0 ? 10 : 40.h),
      child: IconButton(
        //padding: const EdgeInsets.all(8),
        alignment: Alignment.centerLeft,
        enableFeedback: true,
        icon: Image.asset(TImageName.back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
