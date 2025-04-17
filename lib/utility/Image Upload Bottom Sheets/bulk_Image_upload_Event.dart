import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:Happinest/utility/constants/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import '../../common/widgets/iconButton.dart';

class BulkImagePicker extends StatefulWidget {
  final String tripName;
  final Map<DateTime, List<AssetEntity>?> listOfBulkPhotos;
  final Function(List<File?>)? selectedImageList;
  final Function(Map<int, List<AssetEntity>>?, List<File?>? file)? onUpload;

  const BulkImagePicker({
    Key? key,
    required this.tripName,
    required this.listOfBulkPhotos,
    this.selectedImageList,
    this.onUpload,
  }) : super(key: key);

  @override
  _BulkImagePickerState createState() => _BulkImagePickerState();
}

class _BulkImagePickerState extends State<BulkImagePicker>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  final Map<int, List<AssetEntity>> selectedImages = {};
  final Map<int, List<File>> images = {};
  int totalSelectedImages = 0;
  int expandedIndex = 0;
  List<bool> isSelected = [true, false];
  int maxImage = 10;
  bool isloadStsus = false;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ;
    _prepareImages();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (images.isEmpty) {
      _prepareImages();
    }
  }

  Future<void> _prepareImages() async {
    if (widget.listOfBulkPhotos.isNotEmpty) {
      try {
        int i = 0;
        for (var entry in widget.listOfBulkPhotos.entries) {
          List<File> tmpList = [];

          for (AssetEntity element in entry.value ?? []) {
            File? file = await element.file;
            if (file != null) {
              tmpList.add(file); // ✅ Add file to temporary list
              // print("--Added file path-- ${file.path}");
            }
          }

          if (tmpList.isNotEmpty) {
            images[i] = List.from(tmpList); // ✅ Store in images map
            //print("--Images Map Updated-- ${images[i]}");
          }
          i++;
        }
        setState(() {});
      } catch (e) {
        log('Error loading images: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            height: (MediaQuery.sizeOf(context).height),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: topSfarea > 0 ? topSfarea : 0.03.sh, left: 15.w, right: 15.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      iconButton(
                          onPressed: () => Navigator.pop(context),
                          iconPath: TImageName.crossIcon,
                          bgColor: TAppColors.black50),
                      TextButton(
                        onPressed: totalSelectedImages > 0
                            ? () {
                                widget.onUpload!(selectedImages, null);
                              }
                            : null,
                        child: TText(TLabelStrings.addPhoto,
                            maxLines: 1,
                            fontWeight: FontWeight.w700,
                            color: totalSelectedImages > 0
                                ? TAppColors.themeColor
                                : TAppColors.text3Color,
                            fontSize: MyFonts.size18),
                      ),
                    ],
                  ),
                ),
                ((widget.listOfBulkPhotos.values.first?.length ?? 0) == 0)
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(45.0), // Adjust the padding as needed
                          child: Center(
                            child: TText(
                              'No photos for the Event date(s). Please pick from album',
                              color: TAppColors.text1Color,
                              textAlign: TextAlign.center, // This will center the text
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: widget.listOfBulkPhotos.length,
                          itemBuilder: (context, day) {
                            DateTime tripDate = widget.listOfBulkPhotos.keys.elementAt(day);
                            List<AssetEntity> listOfPhotos =
                                widget.listOfBulkPhotos[tripDate] ?? [];
                            return listOfPhotos.isNotEmpty
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(
                                            () {
                                              expandedIndex == day
                                                  ? expandedIndex = 50
                                                  : expandedIndex = day;
                                            },
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                                              child: Text(
                                                "Day ${day + 1} - ${formatDateddMMMyyyy(tripDate.toString(), context)}",
                                                style: getBoldStyle(
                                                  fontSize: MyFonts.size14,
                                                  color: TAppColors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // if (expandedIndex == day)
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 1.5,
                                          mainAxisSpacing: 1.5,
                                        ),
                                        itemCount: listOfPhotos.length,
                                        itemBuilder: (context, index) {
                                          AssetEntity image = listOfPhotos[index];
                                          bool isSelected =
                                              selectedImages[day]?.contains(image) ?? false;
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (isSelected) {
                                                  selectedImages[day]?.remove(image);
                                                } else if (totalSelectedImages < maxImage) {
                                                  selectedImages
                                                      .putIfAbsent(day, () => [])
                                                      .add(image);
                                                }
                                                totalSelectedImages = selectedImages.values
                                                    .fold(0, (sum, list) => sum + list.length);
                                              });
                                            },
                                            child: Stack(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(
                                                        8.0), // Increase radius for better UI
                                                    image: images.isNotEmpty
                                                        ? DecorationImage(
                                                            image: FileImage(
                                                                images[day]!.elementAt(index)),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : null, // No image when empty
                                                    color: images.isEmpty
                                                        ? Colors.grey[300]
                                                        : null, // Placeholder color
                                                  ),
                                                  child: images.isEmpty
                                                      ? const Center(
                                                          child: SizedBox(
                                                            height: 25,
                                                            width: 25,
                                                            child: CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              valueColor: AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  TAppColors
                                                                      .orange), // Customize color
                                                            ),
                                                          ),
                                                        ) // Show loader
                                                      : null, // No overlay when image exists
                                                ),
                                                Positioned(
                                                  top: 6,
                                                  right: 6,
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: isSelected
                                                          ? Colors.white
                                                          : Colors.transparent,
                                                      border: Border.all(
                                                          color: TAppColors.orange, width: 2),
                                                    ),
                                                    child: isSelected
                                                        ? const Icon(
                                                            Icons.check,
                                                            color: TAppColors.orange,
                                                            size: 16,
                                                          )
                                                        : null,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  )
                                : SizedBox.shrink();
                          },
                        ),
                      ),
                TCard(
                    color: Colors.grey.withOpacity(0.2),
                    width: dwidth!,
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h)
                          .copyWith(bottom: bottomSfarea > 0 ? bottomSfarea : 12.h),
                      child: TText(
                        'Selected $totalSelectedImages/$maxImage',
                        color: TAppColors.themeColor,
                        fontSize: 18,
                      ),
                    )))
              ],
            ),
          ),
          Positioned(
            top: topSfarea > 0 ? topSfarea : 0.03.sh,
            left: 0,
            right: 0,
            // Position it at the center of the notch
            child: Align(
              alignment: Alignment.center, // Align widget in the center horizontally

              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TText(
                    widget.tripName.length > 16
                        ? '${widget.tripName.substring(0, 16)}...'
                        : widget.tripName,
                    fontWeight: FontWeight.w600,
                    color: TAppColors.text1Color,
                    fontSize: 18,
                    maxLines: 1, // Limit to 1 line
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  ToggleButtons(
                    isSelected: isSelected,
                    onPressed: (int index) {
                      setState(() {
                        // isSelected = [index == 0, index == 1];
                        if (index == 1) {
                          setState(() async {
                            final picker = ImagePicker();
                            final pickedFile = await picker.pickMultiImage(limit: 10);
                            if (pickedFile.isEmpty) {
                              return;
                            }
                            List<File?>? listOfImages =
                                pickedFile.map((e) => File(e.path)).toList();
                            setState(() {
                              selectedImages.clear();
                              totalSelectedImages = 0;
                              totalSelectedImages += listOfImages.length;
                            });
                            widget.onUpload!(null, listOfImages);
                            // Navigator.pop(context);
                          });
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(17),
                    selectedColor: Colors.white,
                    fillColor: Colors.orange,
                    color: Colors.black,
                    constraints: const BoxConstraints(minHeight: 34.0, minWidth: 80.0),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          " Suggestion",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "Album",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // }),
    );
  }
}
