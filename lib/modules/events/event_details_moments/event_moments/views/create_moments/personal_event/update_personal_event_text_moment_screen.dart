// UpdatePersonalEventScreen
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_create_memories_text_post_model.dart';
import 'package:Happinest/modules/events/event_details_moments/controller/personal_event_memories_controller.dart';
import '../../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../../common/common_imports/common_imports.dart';
import '../../../../../../../common/widgets/appbar.dart';
import '../../../../../../../common/widgets/custom_textfield.dart';
import '../../../../../../../location/location_client.dart';
import '../../../../../../../models/create_event_models/moments/personal_event_moments/personal_event_all_moment_model.dart';

class UpdatePersonalEventTextMomentScreen extends ConsumerStatefulWidget {
  const UpdatePersonalEventTextMomentScreen(
      {super.key, this.eventHeaderId, this.eventTitle, this.token, required this.postModel});
  final int? eventHeaderId;
  final String? token, eventTitle;
  final PersonalEventPost postModel;
  @override
  ConsumerState<UpdatePersonalEventTextMomentScreen> createState() =>
      _UpdatePersonalEventTextMomentScreenState();
}

class _UpdatePersonalEventTextMomentScreenState
    extends ConsumerState<UpdatePersonalEventTextMomentScreen> {
  FocusNode focusNode = FocusNode();
  bool isKeyBoardFocus = false;
  TextEditingController commentController = TextEditingController();
  String text = "";
  @override
  void initState() {
    // TODO: implement initState
    commentController.text = widget.postModel.description ?? '';
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  /// Update Moment
  updateMoment() async {
    PersonalEventCreateMemoriesTextPostModel model = PersonalEventCreateMemoriesTextPostModel(
      createdOn: DateTime.now(),
      personalEventHeaderId: widget.eventHeaderId ?? 0,
      personalEventPostId: widget.postModel.personalEventPostId ?? 0,
      aboutPost: commentController.text,
    );
    await ref.read(personalEventMemoriesController).updatePersonalEventMemoryPostText(
        personalEventCreateMemoriesTextPostModel: model,
        token: widget.token ?? '',
        isSingleMediaPost: false,
        isMultiMediaPost: false,
        isTextPost: true,
        context: context,
        ref: ref);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isKeyBoardFocus = false;
      });
      commentController.clear();
      FocusManager.instance.primaryFocus!.unfocus();
      Navigator.pop(context, true);
    });
  }

  double calculateFontSize(double maxWidth) {
    // You can adjust this logic based on your requirements
    double minFontSize = MyFonts.size12;
    double maxFontSize = MyFonts.size22;
    const double scaleFactor = 0.8;

    double fontSize = maxFontSize;

    while (fontSize > minFontSize) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(fontSize: fontSize),
        ),
        maxLines: null,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: maxWidth);

      if (textPainter.height < 180.h * scaleFactor) {
        break;
      }

      fontSize -= 1.0;
    }

    return fontSize;
  }

  onScreenTap() {
    setState(() {
      isKeyBoardFocus = false;
    });
    FocusManager.instance.primaryFocus!.unfocus();
  }
// compareTextLengths
  void compareTextLengths(BuildContext context, String description, String comment) {
    if (description.length > comment.length) {
      showAlertMessage(context, true);
    } else if (description.length < comment.length) {
      showAlertMessage(context, true);
    } else {
      Navigator.pop(context);
    }
  }

  void showAlertMessage(BuildContext context, bool hideYesaction) {
    showDialog<String>(
        context: context,
        builder: (context) => TDialog(
              title: "Alert!",
              isBack: hideYesaction,
              actionButtonText: TButtonLabelStrings.yesButton,
              bodyText: TMessageStrings.canlcelAction,
              onActionPressed: () {
                Navigator.pop(context);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onScreenTap,
      child: Scaffold(
        backgroundColor: TAppColors.eventScaffoldColor,
        body: Column(
          children: [
            CustomAppBar(
              color: TAppColors.eventScaffoldColor,
              textColor: Colors.white,
              onTap: () {
                compareTextLengths(
                    context, widget.postModel.description ?? '', commentController.text);
              },
              title: TLabelStrings.updateEvent,
              hasSubTitle: true,
              subtitle: widget.eventTitle ?? '',
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      height: 280.h,
                      width: 1.sw,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              TImageName.textMomentBgImage), // Update with your image asset path
                          fit: BoxFit.cover, // You can adjust the fit based on your needs
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.h),
                        child: Center(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Text(
                                commentController.text,
                                textAlign: TextAlign.center,
                                style: getSemiBoldStyle(
                                  fontSize: calculateFontSize(0.8.sw),
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isKeyBoardFocus ? 0.w : 10.w),
              child: TCard(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Row(
                      children: [
                        Consumer(
                          builder: (BuildContext context, WidgetRef ref, Widget? child) {
                            return Expanded(
                              child: CustomTextFieldDesc(
                                  controller: commentController,
                                  hintText: 'Enter the text',
                                  onChanged: (String) {
                                    setState(() {
                                      text = commentController.text;
                                    });
                                  },
                                  onFieldSubmitted: (String) async {},
                                  obscure: false,
                                  maxLines: 4,
                                  minLines: 1,
                                  maxLength: 300,
                                  topPadding: 10.h,
                                  onTap: () {
                                    setState(() {
                                      isKeyBoardFocus = true;
                                    });
                                  }),
                            );
                          },
                        ),
                        InkWell(
                          splashColor: TAppColors.transparent,
                          onTap: updateMoment,
                          child: Image.asset(
                            TImageName.send,
                            height: 24.h,
                            width: 24.h,
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            if (!isKeyBoardFocus)
              SizedBox(
                height: 20.h,
              ),
          ],
        ),
      ),
    );
  }
}
