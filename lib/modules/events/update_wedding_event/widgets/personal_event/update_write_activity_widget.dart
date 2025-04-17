import 'package:Happinest/modules/events/update_wedding_event/controllers/personal_event/update_personal_event_activities_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/custom_textfield.dart';

class UpdateWriteActivityWidget extends StatefulWidget {
  final Function() getCall;
  const UpdateWriteActivityWidget({super.key, required this.getCall});

  @override
  State<UpdateWriteActivityWidget> createState() => _UpdateWriteActivityWidgetState();
}

class _UpdateWriteActivityWidgetState extends State<UpdateWriteActivityWidget> {
  final _interestCtr = TextEditingController();
  bool isFieldOpened = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final manageActivityCtr = ref.watch(updatePersonalEventActivitiesCtr);
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
                    inputType: TextInputType.name,
                    onFieldSubmitted: (val) {
                      if (_interestCtr.text.isNotEmpty) {
                        manageActivityCtr.addWriteByHandActivities(val);
                        widget.getCall();
                        _interestCtr.clear();
                      }
                    },
                    obscure: false,
                    tailingIcon: IconButton(
                        onPressed: () {
                          if (_interestCtr.text.isNotEmpty) {
                            manageActivityCtr.addWriteByHandActivities(_interestCtr.text);
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
                          'Add Activity',
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
