import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/custom_textfield.dart';
import '../../controllers/personal_event_controller/personal_event_activity_controller.dart';

class WriteActivityWidget extends StatefulWidget {
  final Function() getCall;
  const WriteActivityWidget({super.key, required this.getCall});

  @override
  State<WriteActivityWidget> createState() => _WriteActivityWidgetState();
}

class _WriteActivityWidgetState extends State<WriteActivityWidget> {
  final _interestCtr = TextEditingController();
  bool isFieldOpened = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final manageActivityCtr = ref.watch(personalEventActivityCtr);
        return Column(
          children: [
            SizedBox(
              height: 18.h,
            ),
            isFieldOpened
                ? CustomTextField(
              height: 32.h,
              controller: _interestCtr,
              hintText: 'Activity Name',
              onChanged: (val) {},
              inputType: TextInputType.name,
              onFieldSubmitted: (val) {
                if (_interestCtr.text.isNotEmpty) {
                  manageActivityCtr.addWriteByHandActivity(val);
                  widget.getCall();
                  _interestCtr.clear();
                }
              },
              maxLength: 15,
              obscure: false,
              tailingIcon: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    if (_interestCtr.text.isNotEmpty) {
                      manageActivityCtr
                          .addWriteByHandActivity(_interestCtr.text);
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
