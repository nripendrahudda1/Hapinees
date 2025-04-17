import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:Happinest/common/common_default_apis.dart';
import 'package:Happinest/common/widgets/iconButton.dart';
import 'package:Happinest/modules/account/login/provider/profile_view_model.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/account/usermodel/usermodel.dart';
import 'package:Happinest/utility/Image%20Upload%20Bottom%20Sheets/choose_image.dart';
import 'package:Happinest/utility/Validations.dart';
import 'package:Happinest/utility/constants/constants.dart';
import '../../../common/common_functions/common_date_picker.dart';
import '../../../location/location/location_manager.dart';
import '../../../utility/constants/strings/parameter.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, this.user});
  final UserModel? user;
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late String coverImagePath = '';
  late String profileImagePath = '';
  bool isShowError = false;
  late String errorMesage = '';
  late String dateofBirth = '';
  double? lat, longi;
  String userEmail = '';
  File? bgPic;
  File? pPic;

  DateTime currentdate = DateTime.timestamp();
  ProfilePickStatus? selectProfile = ProfilePickStatus.coverImage;
  TextEditingController displayController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController diatryController = TextEditingController();
  TextEditingController eventController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  DateTime? selectDate;
  @override
  void initState() {
    super.initState();
    print("widget.user!.displayName ******* ${widget.user?.displayName}");
    print("widget.user!.displayName ******* ${widget.user?.displayName ?? userEmail.split('@')[0]}");
    if (widget.user != null) {
      userEmail = widget.user!.email ?? '';
      displayController.text = widget.user?.displayName ?? userEmail.split('@')[0];
      firstnameController.text = widget.user!.firstName ?? '';
      lastnameController.text = widget.user!.lastName ?? '';
      aboutController.text = widget.user!.aboutUser ?? '';
      mobileController.text = widget.user!.mobile ?? '';
      dobController.text = widget.user!.birthday != null
          ? formatDateddMMMyyyy((widget.user!.birthday.toString()), context)
          : '';
      widget.user!.birthday != null ? selectDate = DateTime.parse(widget.user!.birthday!) : null;
      addressController.text = widget.user!.address ?? '';
      diatryController.text = widget.user!.foodPreference ?? '';
    } else {
      userEmail = PreferenceUtils.getString(PreferenceKey.email);
      errorMesage = TMessageStrings.emptyFiled;
      displayController.text = userEmail.split('@')[0];
    }
    //_getLocationData();
  }

  @override
  void dispose() {
    super.dispose();
    dismessedData();
  }

  void dismessedData() {
    errorMesage = '';
    displayController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
    mobileController.dispose();
    dobController.dispose();
    addressController.dispose();
    diatryController.dispose();
    eventController.dispose();
    aboutController.dispose();
  }

  errorMessageFuction() async {
    setState(() {
      isShowError = true;
    });
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isShowError = false;
      });
    });
  }

  Future<void> updateUserDetails(BuildContext context, ProfileViewModel userViewModel) async {
    errorMesage = TMessageStrings.emptyFiled;
    Uint8List? stringPPic = await ImagePickerBottomSheet.compressFile(pPic);
    Uint8List? stringBGPic = await ImagePickerBottomSheet.compressFile(bgPic);
    FocusManager.instance.primaryFocus?.unfocus();
    // Perform authentication Signup here
    var serverID = PreferenceUtils.getString(PreferenceKey.serveruserId);
    var deviceid = PreferenceUtils.getString(PreferenceKey.deviceID);
    userViewModel.displayName = displayController.text;
    userViewModel.firstName = firstnameController.text;
    userViewModel.lastName = lastnameController.text;
    userViewModel.mobile = mobileController.text;
    userViewModel.abount = aboutController.text;
    userViewModel.dob = dobController.text;
    userViewModel.address = addressController.text;
    userViewModel.dietpreference = diatryController.text;
    print(userViewModel.displayName.toString());
    if (userViewModel.displayName.isNotEmpty) {
      Map<String, dynamic> params = {
        TPParameters.firstName: userViewModel.firstName,
        TPParameters.lastName: userViewModel.lastName,
        TPParameters.mobileNo: userViewModel.mobile,
        TPParameters.displayName: userViewModel.displayName,
        TPParameters.address: userViewModel.address,
        "countryId": null,
        "gender": "",
        TPParameters.birthday: selectDate?.toIso8601String(),
        TPParameters.foodPreference: userViewModel.dietpreference,
        TPParameters.aboutUser: userViewModel.abount,
        TPParameters.backgroundPicture: stringBGPic != null ? base64.encode(stringBGPic) : null,
        TPParameters.profilePicture: stringPPic != null ? base64.encode(stringPPic) : null
      };
      Loader.showLoader();
      try {
        UserModel? currUser = await userViewModel.updateUserProfile(params, context);
        print("currUser *************** ${userViewModel.userResponse?.validationMessage}");
        print("currUser *************** ${currUser.toString()}");
        Loader.hideLoader();
        if (currUser?.validationMessage == "Success") {
          myProfileData = currUser;
          if (mounted) {
            widget.user != null
                ? Navigator.pop(context)
                : Navigator.pushNamedAndRemoveUntil(context, Routes.homeRoute, (route) => false);
          }
        } else {
          errorMesage = currUser?.validationMessage ?? "";
          if (mounted) {
            errorMessageFuction();
          }
        }
      } catch (e) {
        log('during signup $e');
      }
    } else {
      errorMessageFuction();
    }
  }

  void _getLocationData() async {
    var lobObj = LocationManager();
    lobObj.initLocationService().then((LocationData? result) async {
      lat = result?.latitude;
      longi = result?.longitude;
      var locationAddress = await Utility.getAddress(
        lat,
        longi,
      );
      setState(() {
        addressController.text = locationAddress;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final padding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: TAppColors.profileColor,
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: Platform.isAndroid ? true : false,
        child: Padding(
          padding: const EdgeInsets.all(12).copyWith(bottom: bottomSfarea > 10 ? bottomSfarea : 12),
          child: TButton(
            onPressed: () {
              updateUserDetails(context, profileViewModel);
            },
            title: TButtonLabelStrings.saveButton,
            buttonBackground: TAppColors.appColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(children: [
                Container(
                  height: screenSize.height * 0.25,
                  decoration: bgPic != null
                      ? BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(bgPic!),
                            fit: BoxFit.cover,
                          ),
                        )
                      : widget.user != null &&
                              widget.user!.userBackgroundPictureUrl != null &&
                              widget.user!.userBackgroundPictureUrl != ''
                          ? BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    widget.user!.userBackgroundPictureUrl!),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(TImageName.appBackground),
                                fit: BoxFit.cover,
                              ),
                            ),
                ),
                widget.user != null
                    ? Positioned(
                        left: 20,
                        top: padding == 0.0 ? 35.h : 45.h,
                        child: iconButton(
                          bgColor: TAppColors.text4Color,
                          iconPath: TImageName.back,
                          radius: 24.h,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    : const SizedBox(),
                Positioned(
                    right: 20,
                    top: padding == 0.0 ? 35.h : 45.h,
                    child: iconButton(
                      iconPath: TImageName.camera,
                      radius: 24.h,
                      padding: 5,
                      bgColor: TAppColors.white.withOpacity(0.5),
                      onPressed: () {
                        ImagePickerBottomSheet.show(
                          context,
                          tripName: '',
                          isMultiImage: false,
                          selectedAsset: (p0) {},
                          selectedImageList: (photo) {
                            setState(() {
                              photo != null ? bgPic = photo[0] : null;
                            });
                          },
                        );
                      },
                    ))
              ]),
              const SizedBox(
                height: 70,
              ),
              if (isShowError) CustomErrorWidget(errorMessage: errorMesage),
              SizedBox(
                width: screenSize.width,
                child: Padding(
                  padding: const EdgeInsets.all(10).copyWith(top: 0),
                  child: Column(
                    children: [
                      TText(userEmail,
                          color: TAppColors.themeColor,
                          fontSize: 16,
                          fontWeight: FontWeightManager.bold),
                      const SizedBox(
                        height: 11,
                      ),
                      TTextField(
                        inputboxBoder: TAppColors.inputBoxBorderColor,
                        controller: displayController,
                        textInputType: TextInputType.name,
                        hintText: TPlaceholderStrings.displayName,
                        icon: TImageName.user,
                        enabled: true,
                        onTapOutside: (p0) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            // wrap your Column in Expanded
                            child: TTextField(
                              inputboxBoder: TAppColors.inputBoxBorderColor,
                              controller: firstnameController,
                              textInputType: TextInputType.name,
                              inputFormatter: [AlphabetInputFormatter()],
                              hintText: TPlaceholderStrings.firstName,
                              icon: TImageName.user,
                              enabled: true,
                              onChanged: (p0) {
                                profileViewModel.firstName = p0;
                              },
                              onTapOutside: (p0) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            // wrap your Column in Expanded
                            child: TTextField(
                              inputboxBoder: TAppColors.inputBoxBorderColor,
                              controller: lastnameController,
                              textInputType: TextInputType.name,
                              inputFormatter: [AlphabetInputFormatter()],
                              hintText: TPlaceholderStrings.lastName,
                              icon: TImageName.user,
                              onChanged: (p0) {
                                profileViewModel.lastName = p0;
                              },
                              onTapOutside: (p0) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TTextBoxField(
                        maxLength: 200,
                        controller: aboutController,
                        onChanged: (p0) {
                          profileViewModel.abount = p0;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TTextField(
                        inputboxBoder: TAppColors.inputBoxBorderColor,
                        controller: mobileController,
                        hintText: TPlaceholderStrings.mobile,
                        icon: TImageName.phone,
                        inputFormatter: [LengthLimitingTextInputFormatter(10)],
                        textInputType: TextInputType.phone,
                        onChanged: (p0) {
                          profileViewModel.mobile = p0;
                        },
                        onTapOutside: (p0) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      const SizedBox(height: 10),
                      TTextField(
                        cursorColor: Colors.transparent,
                        isKeyboardUnfocus: true,
                        inputboxBoder: TAppColors.inputBoxBorderColor,
                        controller: dobController,
                        hintText: TPlaceholderStrings.dateOfBirthday,
                        icon: TImageName.calander,
                        onTap: () async {
                          // _selectDate(context);
                          selectDate = await showPlatformDatePicker(context: context);

                          if (selectDate != null) {
                            setState(() {
                              dateofBirth = formatDateddMMMyyyy(selectDate.toString(), context);
                              debugPrint(dateofBirth.toString());
                              dobController.text = dateofBirth;
                            });
                          }
                        },
                        onTapOutside: (p0) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TTextField(
                        inputboxBoder: TAppColors.inputBoxBorderColor,
                        controller: addressController,
                        hintText: TPlaceholderStrings.address,
                        //textInputType: TextInputType.name,
                        // inputFormatter: [AlphabetInputFormatter()],
                        icon: TImageName.locationPngIcon,
                        onChanged: (p0) {
                          profileViewModel.address = p0;
                        },
                        onTapOutside: (p0) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TTextField(
                        inputboxBoder: TAppColors.inputBoxBorderColor,
                        controller: diatryController,
                        hintText: TPlaceholderStrings.dietaryPreference,
                        icon: TImageName.dietary,
                        onChanged: (p0) {
                          profileViewModel.dietpreference = p0;
                        },
                        onTapOutside: (p0) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Positioned(
            top: screenSize.height * 0.25 - 60,
            child: InkWell(
              onTap: () {
                ImagePickerBottomSheet.show(
                  context,
                  tripName: '',
                  isMultiImage: false,
                  selectedAsset: (p0) {},
                  selectedImageList: (photo) {
                    setState(() {
                      photo != null ? pPic = photo[0] : null;
                    });
                  },
                );
              },
              child: widget.user != null &&
                      widget.user!.userProfilePictureUrl != null &&
                      widget.user!.userProfilePictureUrl != '' &&
                      pPic == null
                  ? Stack(
                    children: [
                      CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(widget.user!.userProfilePictureUrl!),
                          radius: 60,
                          child: const SizedBox(),
                        ),
                      Positioned(
                          right: 0,
                          top: padding == 0.0 ? 30.h : 40.h,
                          child: iconButton(
                            iconPath: TImageName.camera,
                            radius: 24.h,
                            padding: 5,
                            bgColor: TAppColors.white.withOpacity(0.5),
                          ))
                    ],
                  )
                  : CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: pPic != null ? FileImage(pPic!) : null,
                      radius: 60,
                      child: pPic != null
                          ? const SizedBox()
                          : const Center(
                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: 40,
                                color: TAppColors.black,
                              ),
                            ),
                    ),
            ),
          ),
        ],
      )),
    );
  }
}
