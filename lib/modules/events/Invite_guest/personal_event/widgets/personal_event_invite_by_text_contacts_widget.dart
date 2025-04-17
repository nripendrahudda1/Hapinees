import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/contact_guest_widget.dart';
import '../../../../../models/create_event_models/create_personal_event_models/post_models/send_personal_event_invite_post_model.dart';
import '../../../event_homepage/personal_event/controller/personal_event_home_controller.dart';

class PersonalEventInviteByTextContactsWidget extends ConsumerStatefulWidget {
  const PersonalEventInviteByTextContactsWidget({super.key});

  @override
  ConsumerState<PersonalEventInviteByTextContactsWidget> createState() =>
      _PersonalEventInviteByTextContactsWidgetState();
}

class _PersonalEventInviteByTextContactsWidgetState
    extends ConsumerState<PersonalEventInviteByTextContactsWidget> {
  final searchCtr = TextEditingController();
  String _searchQuery = '';
  List<Contact> _contacts = [];
  final List<Contact> _selectedContacts = [];

  @override
  initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void dispose() {
    searchCtr.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    List<Contact> contacts = await FlutterContacts.getContacts(withProperties: true);
    setState(() {
      _contacts = contacts;
    });
  }

  List<Contact> _searchContacts() {
    if (_searchQuery.isEmpty) {
      return _contacts;
    }

    return _contacts.where((contact) {
      return contact.displayName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          contact.phones.any((phone) => phone.number.contains(_searchQuery));
    }).toList();
  }

  void _printSelectedContacts() {
    for (Contact contact in _selectedContacts) {
      print('Selected Contact: ${contact.displayName}');
    }
  }

  void _onContactSelected(bool selected, Contact contact) {
    setState(() {
      if (selected) {
        _selectedContacts.add(contact);
      } else {
        _selectedContacts.remove(contact);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Contact> displayedContacts = _searchContacts();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(15.w),
          child: Row(
            children: [
              Text(
                "Contacts",
                style: getSemiBoldStyle(fontSize: MyFonts.size12, color: TAppColors.black),
              ),
              SizedBox(
                width: 10.w,
              ),
              CircleAvatar(
                radius: 8.r,
                backgroundColor: TAppColors.appColor,
                child: Center(
                  child: Text(
                    _selectedContacts.length.toString(),
                    style: getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.white),
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.w, right: 10.w, top: 0.h),
          child: Row(
            children: [
              Expanded(
                child: TCard(
                    height: 40.h,
                    border: true,
                    borderColor: TAppColors.greyText,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            TImageName.search,
                            height: 20,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: CTTextField(
                            controller: searchCtr,
                            hint: 'Find Member',
                            onChanged: (query) {
                              setState(() {
                                _searchQuery = query;
                              });
                            },
                            onTapOutside: (p0) {
                              FocusScope.of(context).unfocus();
                            },
                          )),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0.w),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 20.h,
                );
              },
              physics: const BouncingScrollPhysics(),
              itemCount: displayedContacts.length,
              itemBuilder: (context, index) {
                Contact contact = displayedContacts[index];
                bool isSelected = _selectedContacts.contains(contact);
                return ContactGuestWidget(
                    phNumber:
                        contact.phones.isNotEmpty ? contact.phones.first.number : 'No phone number',
                    name: contact.displayName,
                    trailing: Checkbox(
                      value: isSelected,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                      onChanged: (bool? value) {
                        if (value != null) {
                          _onContactSelected(value, contact);
                        }
                      },
                    ));
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.h, bottom: 15.w, left: 15.w, right: 15.w),
          child: Row(
            children: [
              Expanded(
                child: TBounceAction(
                  onPressed: () async {
                    // _printSelectedContacts();
                    // if (inviteByPhoneKey.currentState!.validate()) {
                    List<PersonalEventInvite> inviteModels = [];
                    for (var phone in _selectedContacts) {
                      print(phone.displayName);
                      if (phone.phones.isNotEmpty) {
                        inviteModels.add(PersonalEventInvite(
                          email: '',
                          mobile: phone.phones.first.toString(),
                        ));
                      }
                    }
                    SendPersonalEventInvitePostModel model = SendPersonalEventInvitePostModel(
                        inviteStatus: 1,
                        invitedBy: getUserID(),
                        personalEventInviteId: 0,
                        personalEventHeaderId: ref
                                .watch(personalEventHomeController)
                                .homePersonalEventDetailsModel
                                ?.personalEventHeaderId ??
                            0,
                        invitedOn: DateTime.now(),
                        personalEventInvites: inviteModels);
                    await ref.watch(personalEventGuestInviteController).sendPersonalEventInvite(
                        sendPersonalEventInvitePostModel: model, ref: ref, context: context);
                    // for (var email in _phControllers) {
                    //   email.clear();
                    // }
                    _selectedContacts.clear();
                    // Navigator.pop(context);
                    // }
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
                                color: TAppColors.white, fontSize: MyFonts.size14),
                          ),
                        ),
                      ),
                      color: TAppColors.buttonBlue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
