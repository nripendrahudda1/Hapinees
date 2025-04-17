import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/wedding_event/update_wedding_rituals_controller.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/custom_textfield.dart';

class UpdateWriteRitualsWidget extends StatefulWidget {
  final Function() getCall;
  const UpdateWriteRitualsWidget({super.key, required this.getCall});

  @override
  State<UpdateWriteRitualsWidget> createState() => _UpdateWriteRitualsWidgetState();
}

class _UpdateWriteRitualsWidgetState extends State<UpdateWriteRitualsWidget> {
  final _interestCtr = TextEditingController();
  bool isFieldOpened = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final manageStylesCtr = ref.watch(updateWeddingRitualsCtr);
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
                        manageStylesCtr.addWriteByHandRituals(val);
                        widget.getCall();
                        _interestCtr.clear();
                      }
                    },
                    obscure: false,
                    tailingIcon: IconButton(
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
