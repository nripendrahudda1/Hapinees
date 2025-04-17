import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/set_email_post_template.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/widgets/custom_textfield.dart';

import '../../../../../common/common_imports/common_imports.dart';

class CommonReminderDialog extends ConsumerStatefulWidget {
  const CommonReminderDialog({
    super.key,
    required this.title,
    required this.onTap,
    required this.textEditingCtr,
  });
  final String title;
  final Function() onTap;
  final TextEditingController textEditingCtr;

  @override
  ConsumerState<CommonReminderDialog> createState() => _CommonReminderDialogState();
}

class _CommonReminderDialogState extends ConsumerState<CommonReminderDialog> {
  String stripHtmlTags(String htmlString) {
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(regex, '').replaceAll('&nbsp;', ' ').trim();
  }

  void sendEmail() async {
    final inviteCtr = ref.watch(personalEventGuestInviteController);
    final personalEventCtr = ref.watch(personalEventHomeController);
    SendPostEmailTemplateModel model = SendPostEmailTemplateModel(
        emailBody: inviteCtr.getEmailTemplateType?.emailTemplate?.emailBody ?? "",
        emailSubject: inviteCtr.getEmailTemplateType?.emailTemplate?.emailSubject ?? "",
        eventId: inviteCtr.getEmailTemplateType?.emailTemplate?.eventTypeId ?? 0,
        fromEmail: personalEventCtr.homePersonalEventDetailsModel?.createdBy?.email ?? "");
    await inviteCtr.sendEmailToGuest(sendEmailPostModel: model, ref: ref, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final inviteCtr = ref.watch(personalEventGuestInviteController);
    final plainTextBody =
        stripHtmlTags(inviteCtr.getEmailTemplateType?.emailTemplate?.emailBody ?? "");
    final textEditingCtr = TextEditingController(text: plainTextBody);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(15.h),
          width: double.infinity,
          decoration: BoxDecoration(
            color: TAppColors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                // spreadRadius: 12,
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       inviteCtr.getEmailTemplateType?.emailTemplate?.emailSubject ?? "",
              //       style: getSemiBoldStyle(color: TAppColors.black, fontSize: MyFonts.size18),
              //       maxLines: 2,
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.of(context).pop();
              //       },
              //       child: Image.asset(TImageName.crossPngIcon, width: 16.w, height: 16.h),
              //     )
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      inviteCtr.getEmailTemplateType?.emailTemplate?.emailSubject ?? "",
                      style: getSemiBoldStyle(color: TAppColors.black, fontSize: MyFonts.size18),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.w), // optional spacing
                      child: Image.asset(TImageName.crossPngIcon, width: 16.w, height: 16.h),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              CustomTextField(
                controller: textEditingCtr,
                onFieldSubmitted: (val) {},
                topPadding: 20.h,
                onChanged: (val) {},
                height: 200.h,
                hintText: "Write about the event",
                minLines: 20,
                maxLines: 20,
                obscure: false,
              ),
              SizedBox(
                height: 25.h,
              ),
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return TButton(
                    onPressed: () {
                      // sendEmail();
                      widget.onTap();
                      Navigator.pop(context);
                    },
                    title: 'SEND',
                    buttonBackground: TAppColors.appColor,
                    fontSize: MyFonts.size14,
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
