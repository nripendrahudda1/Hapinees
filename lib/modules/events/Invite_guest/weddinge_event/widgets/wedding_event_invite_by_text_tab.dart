import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'wedding_event_invite_by_text_contacts_widget.dart';
import 'wedding_event_invite_by_text_textfields_widget.dart';

class WeddingEventInviteByTextTab extends StatefulWidget {
  const WeddingEventInviteByTextTab({super.key});

  @override
  State<WeddingEventInviteByTextTab> createState() => _WeddingEventInviteByTextTabState();
}

class _WeddingEventInviteByTextTabState extends State<WeddingEventInviteByTextTab> {
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
            ? const WeddingEventInviteByTextContactsWidget()
            : const WeddingEventInviteByTextTextFieldsWidget(),
      ),
    );
  }
}
