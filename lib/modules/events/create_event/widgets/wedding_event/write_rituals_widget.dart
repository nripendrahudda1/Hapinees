import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/create_event/controllers/wedding_controllers/wedding_activity_controller.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/custom_textfield.dart';

class WriteRitualsWidget extends StatefulWidget {
  final Function() getCall;
  const WriteRitualsWidget({super.key, required this.getCall});

  @override
  State<WriteRitualsWidget> createState() => _WriteRitualsWidgetState();
}

class _WriteRitualsWidgetState extends State<WriteRitualsWidget> {
  final _interestCtr = TextEditingController();
  bool isFieldOpened = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final manageStylesCtr = ref.watch(weddingActivityCtr);
        return Column(
          children: [
            SizedBox(
              height: 18.h,
            ),
            isFieldOpened
                ? CustomTextField(
                    height: 32.h,
                    controller: _interestCtr,
                    hintText: 'Ritual Name',
                    onChanged: (val) {},
                    inputType: TextInputType.name,
                    onFieldSubmitted: (val) {
                      if (_interestCtr.text.isNotEmpty) {
                        manageStylesCtr.addWriteByHandRituals(val);
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
                            manageStylesCtr
                                .addWriteByHandRituals(_interestCtr.text);
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
                          'Add Ritual',
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
