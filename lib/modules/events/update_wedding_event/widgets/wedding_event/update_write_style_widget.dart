import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/wedding_event/update_wedding_style_controller.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/custom_textfield.dart';

class UpdateWriteStyleWidget extends StatefulWidget {
  final Function() getCall;
  const UpdateWriteStyleWidget({super.key, required this.getCall});

  @override
  State<UpdateWriteStyleWidget> createState() => _UpdateWriteStyleWidgetState();
}

class _UpdateWriteStyleWidgetState extends State<UpdateWriteStyleWidget> {
  final _interestCtr = TextEditingController();
  bool isFieldOpened = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final manageStylesCtr = ref.watch(updateWeddingStylesCtr);
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
                        manageStylesCtr.addWriteByHandStyle(val);
                        manageStylesCtr.removeSelectedStyle();
                        widget.getCall();
                        _interestCtr.clear();
                      }
                    },
                    obscure: false,
                    tailingIcon: IconButton(
                        onPressed: () {
                          if (_interestCtr.text.isNotEmpty) {
                            manageStylesCtr
                                .addWriteByHandStyle(_interestCtr.text);
                            manageStylesCtr.removeSelectedStyle();
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
                          'Add Your Own Style',
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
