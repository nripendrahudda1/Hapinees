import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/create_event/controllers/wedding_controllers/wedding_style_controller.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/custom_textfield.dart';


class WriteStyleWidget extends StatefulWidget {
  final Function() getCall;
  const WriteStyleWidget({super.key, required this.getCall});

  @override
  State<WriteStyleWidget> createState() => _WriteStyleWidgetState();
}

class _WriteStyleWidgetState extends State<WriteStyleWidget> {

  final _interestCtr = TextEditingController();
  bool isFieldOpened = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final manageStylesCtr = ref.watch(weddingStylesCtr);
        return Column(
          children: [
            SizedBox(
              height: 18.h,
            ),
            isFieldOpened ?
            CustomTextField(
              height: 32.h,
              maxLength: 20,
              controller: _interestCtr,
              hintText: 'Style Name',
              onChanged: (val){},
              inputType: TextInputType.name,
              onFieldSubmitted: (val){
                if(_interestCtr.text.isNotEmpty){
                  manageStylesCtr.addWriteByHandStyle(val);
                  manageStylesCtr.removeSelectedStyle();
                  widget.getCall();
                  _interestCtr.clear();
                }
              },
              obscure: false,
              tailingIcon: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: (){
                    if(_interestCtr.text.isNotEmpty){
                      manageStylesCtr.addWriteByHandStyle(_interestCtr.text);
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
                :
            GestureDetector(
              onTap: (){
                setState(() {
                  isFieldOpened = true;
                });
              },
              child: Row(
                children: [
                  Image.asset(TImageName.addIcon, width: 24.w , height: 24.h,),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text('Add Your Own Style', style: getRegularStyle(
                    color: TAppColors.themeColor,
                    fontSize: MyFonts.size14,
                  ),)
                ],
              ),
            ),
          ],
        );
      },

    );
  }
}
