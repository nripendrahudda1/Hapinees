import 'package:Happinest/common/common_imports/common_imports.dart';
import 'iconButton.dart';

class CustomDialog extends StatefulWidget {
  @override
  _CustomDialogState createState() => _CustomDialogState();

  final Function() onConfirm;
  final String yesButtonTitle;
  final String noButtonTitle;
  final String? imageName;
  final String? titleSttring;
  const CustomDialog(
      {super.key,
      required this.onConfirm,
      required this.yesButtonTitle,
      required this.noButtonTitle,
      this.imageName,
      this.titleSttring});
}

// ignore: long-method
class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: TAppColors.lightBorderColor.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Column(
                children: [
                  viewUI(),
                  const SizedBox(height: 20),
                  buttons(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget viewUI() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        (widget.imageName != null)
            ? SizedBox(
                child: Image.asset(widget.imageName ?? "",
                    width: 60.w, height: 60.h),
              )
            : const SizedBox(),
        const SizedBox(height: 20),
        TText(
          widget.titleSttring ?? "",
          color: TAppColors.white,
          textAlign: TextAlign.center,
          fontSize: MyFonts.size14,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget buttons(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: TBounceAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: TCard(
                radius: 5,
                color: Colors.white38,
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TText(widget.noButtonTitle,
                      fontSize: 14, fontWeight: FontWeight.bold),
                ))),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TBounceAction(
            onPressed: () {
              widget.onConfirm();
            },
            child: TCard(
              color: TAppColors.orange,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TText(widget.yesButtonTitle,
                    fontSize: 14, fontWeight: FontWeight.bold),
              )),
            ),
          ),
        ),
      ],
    );
  }
}

class TDialog extends StatelessWidget {
  const TDialog({
    required this.title,
    required this.bodyText,
    required this.onActionPressed,
    required this.actionButtonText,
    this.isBack,
    super.key, this.textField,
  });
  final String title;
  final Function() onActionPressed;
  final String bodyText;
  final String actionButtonText;
  final bool? isBack;
  final Widget? textField;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: TCard(
          color: TAppColors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.h,
                    ),
                    Expanded(
                      child: Center(
                        child: TText(title,
                            fontSize: 20,
                            fontWeight: FontWeightManager.semiBold,
                            color: TAppColors.black),
                      ),
                    ),
                    iconButton(
                        padding: 0,
                        radius: 28.w,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconPath: TImageName.cancelIcon),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: textField != null ? 0 : 20, top: textField != null ? 0 : 20),
                  child: TText(bodyText,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.normal,
                      color: TAppColors.black),
                ),
                textField ?? const SizedBox(),
                TBounceAction(
                  onPressed: () async {
                    (isBack ?? true) ? Navigator.pop(context) : null;
                    await onActionPressed();
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: TCard(
                            radius: 100,
                            color: TAppColors.themeColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: TText(actionButtonText.toUpperCase(),
                                    fontSize: 16,
                                    fontWeight: FontWeightManager.semiBold),
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
