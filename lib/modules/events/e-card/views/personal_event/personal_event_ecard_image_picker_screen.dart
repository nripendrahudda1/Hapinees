import 'package:Happinest/modules/events/e-card/controllers/personal_event_ecard_controller.dart';
import 'package:Happinest/modules/events/e-card/views/personal_event/personal_event_ecard_image_cropper.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/appbar.dart';
import '../../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../../common/widgets/image_upload_dialogue.dart';
import '../../../../../utility/constants/constants.dart';
import '../../../../memories/memories_details.dart';

class PersonalEventEcardImagePickerScreen extends ConsumerStatefulWidget {
  const PersonalEventEcardImagePickerScreen({
    super.key,
    this.onImageUpload,
  });
  final Function()? onImageUpload;
  @override
  ConsumerState<PersonalEventEcardImagePickerScreen> createState() => _PersonalEventEcardImagePickerScreenState();
}

class _PersonalEventEcardImagePickerScreenState extends ConsumerState<PersonalEventEcardImagePickerScreen> {
  String selectedImages = '';
  List<String> totalImages = [];

  @override
  void initState() {
    totalImages = ref.read(personalEventECardCtr).personalEventAllImagesList.map((e) {
      return e.imageUrl ?? '';
    }).toList();

    super.initState();
  }

  storeImage(String image) async {
    ref.read(personalEventECardCtr).setCurrentImage(image);
  }


  Future<void> showImagesucessDialog(int totalImages) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return UploadSucessDialog(
          totalImages: totalImages,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15).copyWith(top: 0),
      ),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        onTap: () => Navigator.pop(context),
        title: TNavigationTitleStrings.editECard,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 12),
              child: memoryDetailsWidget(
                  isDayVisible: false,
                  tripName: ref.read(personalEventHomeController).homePersonalEventDetailsModel!.title.toString()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TText('Select only 1 image', color: TAppColors.text2Color),
                ],
              ),
            ),
            SizedBox(
              height: 0.5.sh,
              child: TCard(
                  width: dwidth,
                  border: true,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: totalImages.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8),
                      itemBuilder: (context, index) {
                        return Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImages==
                                        totalImages[index]
                                        ? selectedImages = ''
                                        : selectedImages = totalImages[index];
                                    storeImage(selectedImages);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PersonalEventEcardImagePCropper(
                                                selectedImage: selectedImages,
                                              ),
                                        ));
                                  });
                                },
                                child: TCard(
                                  border: selectedImages.contains(
                                      totalImages[index]),
                                  borderWidth: 4,
                                  radius: 12,
                                  borderColor: TAppColors.selectionColor,
                                  child:
                                  CachedRectangularNetworkImageWidget(
                                      image: totalImages[index],
                                      width: double.maxFinite,
                                      radius: 8,
                                      height: double.maxFinite),
                                ),
                              ),
                            ],
                          );
                      },
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}