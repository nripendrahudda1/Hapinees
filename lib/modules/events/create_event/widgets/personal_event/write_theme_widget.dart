import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/custom_textfield.dart';
import '../../controllers/personal_event_controller/baby_shower_themes_controller.dart';

class WriteThemesWidget extends StatefulWidget {
  final Function() getCall;
  const WriteThemesWidget({super.key, required this.getCall});

  @override
  State<WriteThemesWidget> createState() => _WriteThemesWidgetState();
}

class _WriteThemesWidgetState extends State<WriteThemesWidget> {

  final _interestCtr = TextEditingController();
  bool isFieldOpened = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final manageStylesCtr = ref.watch(personalEventThemesCtr);
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
                  manageStylesCtr.addWriteByHandThemes(val);
                  manageStylesCtr.removeSelectedTheme();
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
                      manageStylesCtr.addWriteByHandThemes(_interestCtr.text);
                      manageStylesCtr.removeSelectedTheme();
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