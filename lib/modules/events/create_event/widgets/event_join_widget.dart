import 'package:Happinest/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/common_imports/common_imports.dart';

class EventJoinWidget extends ConsumerStatefulWidget {
  const EventJoinWidget({super.key});

  @override
  ConsumerState<EventJoinWidget> createState() => _EventJoinWidgetState();
}

class _EventJoinWidgetState extends ConsumerState<EventJoinWidget> {
  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TText("Have an event code? ", fontSize: 16.h, color: customColors.text2Color),
        GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: TText("Join Here",
                fontSize: 16.h,
                color: TAppColors.themeColor,
                decoration: TextDecoration.underline,
                decorationColor: TAppColors.themeColor)),
      ],
    );
  }
}
