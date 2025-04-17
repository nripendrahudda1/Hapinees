import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/send_wedding_invite_post_model.dart';
import 'package:Happinest/utility/Validations.dart';

import '../../../../../common/widgets/custom_textfield.dart';
import '../controller/wedding_invite_guests_controller.dart';

class WeddingEventInviteByEmailTab extends StatefulWidget {
  const WeddingEventInviteByEmailTab({super.key});

  @override
  State<WeddingEventInviteByEmailTab> createState() =>
      _WeddingEventInviteByEmailTabState();
}

class _WeddingEventInviteByEmailTabState extends State<WeddingEventInviteByEmailTab> {
  final List<CustomInviteTextField> _emailFields = [];
  final List<TextEditingController> _emailControllers = [];
  GlobalKey<FormState> inviteByEmailKey = GlobalKey<FormState>();

  @override
  initState() {
    createEmailField();
    createEmailField();
    super.initState();
  }

  @override
  dispose(){
    super.dispose();
    for (final controller in _emailControllers) {
      controller.dispose();
    }
  }

  createEmailField() {
    final ctr = TextEditingController();

    final titleField = CustomInviteTextField(
      controller: ctr,
      validatorFn: emailValidator,
      onChanged: (val) {},
      onFieldSubmitted: (val) {},
      hintText: "Enter The Email Address",
      obscure: false,
    );

    setState(() {
      _emailFields.add(titleField);
      _emailControllers.add(ctr);
    });
  }

  Widget _listViewOfEmailFields() {
    final children = [
      for (var i = 0; i < _emailFields.length; i++)
        Column(
          children: [
            Row(
              children: [
                Expanded(child: _emailFields[i]),
                SizedBox(
                  width: 12.w,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _emailFields.removeAt(i);
                      _emailControllers.removeAt(i);
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
    return Expanded(
      child: Container(
        color: TAppColors.white,
        child: Padding(
          padding: EdgeInsets.all(15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Form(
                          key: inviteByEmailKey,
                          child: Column(
                            children: [
                              _listViewOfEmailFields(),
                            ],
                          )),
                      const SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: createEmailField,
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
                      onPressed: () async{
                        if (inviteByEmailKey.currentState!.validate()) {
                          List<WeddingInvite> inviteModels = [];
                          for (var email in _emailControllers) {
                            print(email.text);
                            inviteModels.add(WeddingInvite(
                              email: email.text
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
                          for (var email in _emailControllers) {
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
      ),
    );
  }
}
