import 'package:Happinest/modules/events/Invite_guest/personal_event/widgets/personal_event_invite_by_text_contacts_widget.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/widgets/personal_event_invite_by_text_textfields_widget.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../../../common/common_imports/common_imports.dart';

class PersonalEventInviteByTextTab extends StatefulWidget {
  const PersonalEventInviteByTextTab({super.key});

  @override
  State<PersonalEventInviteByTextTab> createState() => _PersonalEventInviteByTextTabState();
}

class _PersonalEventInviteByTextTabState extends State<PersonalEventInviteByTextTab> {
  bool _hasPermission = false;

  @override
  initState() {
    _checkPermissionStatus();
    super.initState();
  }

  Future<void> _checkPermissionStatus() async {
    bool hasPermission = await FlutterContacts.requestPermission();
    setState(() {
      _hasPermission = hasPermission;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: TAppColors.white,
        child: (_hasPermission)
            ? const PersonalEventInviteByTextContactsWidget()
            : const PersonalEventInviteByTextTextFieldsWidget(),
      ),
    );
  }
}