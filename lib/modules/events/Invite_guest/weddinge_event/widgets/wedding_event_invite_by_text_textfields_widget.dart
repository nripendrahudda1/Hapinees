import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/utility/Validations.dart';
import '../../../../../common/widgets/custom_textfield.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/send_wedding_invite_post_model.dart';
import '../controller/wedding_invite_guests_controller.dart';

class WeddingEventInviteByTextTextFieldsWidget extends StatefulWidget {
  const WeddingEventInviteByTextTextFieldsWidget({super.key});

  @override
  State<WeddingEventInviteByTextTextFieldsWidget> createState() =>
      _WeddingEventInviteByTextTextFieldsWidgetState();
}

class _WeddingEventInviteByTextTextFieldsWidgetState
    extends State<WeddingEventInviteByTextTextFieldsWidget> {
  final List<CustomInviteTextField> _phoneNumberFields = [];
  final List<TextEditingController> _phControllers = [];
  GlobalKey<FormState> inviteByPhoneKey = GlobalKey<FormState>();

  @override
  initState() {
    createPhoneField();
    createPhoneField();
    super.initState();
  }
  @override
  dispose(){
    super.dispose();
    for (final controller in _phControllers) {
      controller.dispose();
    }
  }
  createPhoneField() {
    final ctr = TextEditingController();

    final titleField = CustomInviteTextField(
      controller: ctr,
      validatorFn: validatePhoneCustom,
      onChanged: (val) {},
      onFieldSubmitted: (val) {},
      hintText: "Enter the Mobile Number",
      obscure: false,
    );

    setState(() {
      _phoneNumberFields.add(titleField);
      _phControllers.add(ctr);
    });
  }

  Widget _listViewOfPhoneFields() {
    final children = [
      for (var i = 0; i < _phoneNumberFields.length; i++)
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _phoneNumberFields[i]),
                SizedBox(
                  width: 12.w,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _phoneNumberFields.removeAt(i);
                      _phControllers.removeAt(i);
                    });
                  },
                  child: Image.asset(
                    TImageName.delete,
                    height: 20,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
          ],
        )
    ];
    return SingleChildScrollView(
      child: Column(
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(15.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Form(
                key: inviteByPhoneKey,
                child: Column(
                  children: [
                    _listViewOfPhoneFields(),
                  ],
                )),
            const SizedBox(
              height: 8,
            ),
            InkWell(
              onTap: createPhoneField,
              child: Container(
                color: TAppColors.white,
                child: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: TAppColors.greyText,
                      size: 14.h,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      'Add More Co-Author',
                      style: getSemiBoldStyle(
                          color: TAppColors.buttonBlue,
                          fontSize: MyFonts.size12),
                    ),
                  ],
                ),
              ),
            ),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final inviteCtr = ref.watch(weddingEventGuestInviteController);

                return Padding(
                  padding: EdgeInsets.only(top: 30.h, bottom: 8.w),
                  child: TBounceAction(
                    onPressed: ()async {
                      if (inviteByPhoneKey.currentState!.validate()) {
                        List<WeddingInvite> inviteModels = [];
                        for (var phone in _phControllers) {
                          print(phone.text);
                          inviteModels.add(WeddingInvite(
                              mobile: phone.text
                          ));
                        }
                        SendWeddingInvitePostModel model = SendWeddingInvitePostModel(
                            weddingHeaderId: ref.watch(weddingEventHomeController).homeWeddingDetails?.weddingHeaderId ?? 0,
                            invitedOn: DateTime.now(),
                            weddingInvites: inviteModels
                        );
                        await inviteCtr.sendWeddingInvite(
                            sendWeddingInvitePostModel: model,
                            ref: ref,
                            context: context
                        );
                        for (var email in _phControllers) {
                          email.clear();
                        }
                        // Navigator.pop(context);
                      }
                    },
                    child: TCard(
                        radius: 24,
                        height: 40.h,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Center(
                            child: Text(
                              TButtonLabelStrings.inviteMember,
                              style: getRobotoBoldStyle(
                                  color: TAppColors.white,
                                  fontSize: MyFonts.size14),
                            ),
                          ),
                        ),
                        color: TAppColors.buttonBlue),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
