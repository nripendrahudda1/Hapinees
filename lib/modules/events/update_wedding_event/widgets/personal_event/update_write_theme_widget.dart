import 'package:Happinest/modules/events/update_wedding_event/controllers/personal_event/update_persoanl_event_theme_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/custom_textfield.dart';

class UpdateWriteThemeWidget extends StatefulWidget {
  final Function() getCall;
  const UpdateWriteThemeWidget({super.key, required this.getCall});

  @override
  State<UpdateWriteThemeWidget> createState() => _UpdateWriteThemeWidgetState();
}

class _UpdateWriteThemeWidgetState extends State<UpdateWriteThemeWidget> {
  final _interestCtr = TextEditingController();
  bool isFieldOpened = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final manageThemeCtr = ref.watch(updatePersonalEventThemCtr);
        return Column(
          children: [
            SizedBox(
              height: 18.h,
            ),
            isFieldOpened
                ? CustomTextField(
              height: 32.h,
              controller: _interestCtr,
              hintText: 'type it out',
              onChanged: (val) {},
              maxLength: 20,
              inputType: TextInputType.name,
              onFieldSubmitted: (val) {
                if (_interestCtr.text.isNotEmpty) {
                  manageThemeCtr.addWriteByHandThemes(val);
                  manageThemeCtr.removeSelectedTheme();
                  widget.getCall();
                  _interestCtr.clear();
                }
              },
              obscure: false,
              tailingIcon: IconButton(
                  onPressed: () {
                    if (_interestCtr.text.isNotEmpty) {
                      manageThemeCtr
                          .addWriteByHandThemes(_interestCtr.text);
                      manageThemeCtr.removeSelectedTheme();
                      widget.getCall();
                      _interestCtr.clear();
                    }
                  },
                  icon: Image.asset(
                    TImageName.tickIcon,
                    width: 24.w,
                    height: 24.h,
                  )),
            )
                : GestureDetector(
              onTap: () {
                setState(() {
                  isFieldOpened = true;
                });
              },
              child: Row(
                children: [
                  Image.asset(
                    TImageName.addIcon,
                    width: 24.w,
                    height: 24.h,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    'Add Your Own Theme',
                    style: getRegularStyle(
                      color: TAppColors.themeColor,
                      fontSize: MyFonts.size14,
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}