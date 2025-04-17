import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/iconButton.dart';

class CustomDialogEvent extends StatelessWidget {
  const CustomDialogEvent({
    required this.title,
    required this.bodyText,
    required this.onActionPressed,
    required this.actionButtonText,
    this.isBack,
    super.key,
  });
  final String title;
  final VoidCallback onActionPressed;
  final String bodyText;
  final String actionButtonText;
  final bool? isBack;
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        radius: 24.w,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconPath: TImageName.cancelIcon),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 20),
                  child: TText('Are you sure want to delete Games ?',
                      textAlign: TextAlign.left,
                      fontWeight: FontWeight.w800,
                      color: TAppColors.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 5),
                  child: TText(bodyText,
                      textAlign: TextAlign.left,
                      fontWeight: FontWeight.normal,
                      color: TAppColors.black),
                ),
                TBounceAction(
                  onPressed: onActionPressed,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TCard(
                            radius: 100,
                            color: TAppColors.buttonRed,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: TText(actionButtonText.toUpperCase(),
                                    textAlign: TextAlign.center,
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