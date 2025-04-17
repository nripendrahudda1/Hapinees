import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateEventMoreInfoExpandedCtr =
    ChangeNotifierProvider((ref) => UpdateEventMoreInfoExpandedController());

class UpdateEventMoreInfoExpandedController extends ChangeNotifier {
  bool _bgImageExpanded = false;
  bool get bgImageExpanded => _bgImageExpanded;
  setBgImageExpanded() {
    _bgImageExpanded = true;
    _messageFromHostExpanded = false;
    _venueExpanded = false;
    _invitationExpanded = false;
    _bgMusicExpanded = false;
    notifyListeners();
  }

  setBgImageUnExpanded() {
    _bgImageExpanded = false;
    _messageFromHostExpanded = true;
    _venueExpanded = false;
    _invitationExpanded = false;
    _bgMusicExpanded = false;
    notifyListeners();
  }

  bool _messageFromHostExpanded = false;
  bool get messageFromHostExpanded => _messageFromHostExpanded;
  setMessageFromHostExpanded() {
    _bgImageExpanded = false;
    _messageFromHostExpanded = true;
    _venueExpanded = false;
    _invitationExpanded = false;
    _bgMusicExpanded = false;
    notifyListeners();
  }

  setMessageFromHostUnExpanded() {
    _bgImageExpanded = false;
    _messageFromHostExpanded = false;
    _venueExpanded = true;
    _invitationExpanded = false;
    _bgMusicExpanded = false;
    notifyListeners();
  }

  bool _venueExpanded = false;
  bool get venueExpanded => _venueExpanded;
  setVenueExpanded() {
    _bgImageExpanded = false;
    _messageFromHostExpanded = false;
    _venueExpanded = true;
    _invitationExpanded = false;
    _bgMusicExpanded = false;
    notifyListeners();
  }

  setVenueUnExpanded() {
    _bgImageExpanded = false;
    _messageFromHostExpanded = false;
    _venueExpanded = false;
    _invitationExpanded = true;
    _bgMusicExpanded = false;
    notifyListeners();
  }

  bool _invitationExpanded = false;
  bool get invitationExpanded => _invitationExpanded;
  setInvitationExpanded() {
    _bgImageExpanded = false;
    _messageFromHostExpanded = false;
    _venueExpanded = false;
    _invitationExpanded = true;
    _bgMusicExpanded = false;
    notifyListeners();
  }

  setInvitationUnExpanded() {
    _bgImageExpanded = false;
    _messageFromHostExpanded = false;
    _venueExpanded = false;
    _invitationExpanded = false;
    _bgMusicExpanded = true;
    notifyListeners();
  }

  bool _bgMusicExpanded = false;
  bool get bgMusicExpanded => _bgMusicExpanded;
  setBgMusicExpanded() {
    _bgImageExpanded = false;
    _messageFromHostExpanded = false;
    _venueExpanded = false;
    _invitationExpanded = false;
    _bgMusicExpanded = true;
    notifyListeners();
  }

  setBgMusicUnExpanded() {
    _bgImageExpanded = false;
    _messageFromHostExpanded = false;
    _venueExpanded = false;
    _invitationExpanded = false;
    _bgMusicExpanded = false;
    notifyListeners();
  }



}
