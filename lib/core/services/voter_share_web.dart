import 'dart:js_interop';

import '../models/models.dart';

@JS('shareVoterCard')
external JSPromise<JSBoolean> _shareVoterCard(
  JSString name,
  JSString relationLabel,
  JSString relationName,
  JSString village,
  JSString serial,
  JSString part,
  JSString epic,
  JSString house,
  JSString age,
  JSString gender,
  JSString page,
);

Future<bool> shareVoterCard(VoterResult voter) async {
  final shared = await _shareVoterCard(
    voter.name.toJS,
    voter.relationLabel.toJS,
    voter.relationName.toJS,
    voter.village.toJS,
    voter.serial.toJS,
    voter.part.toJS,
    voter.epic.toJS,
    voter.house.toJS,
    voter.age.toJS,
    voter.gender.toJS,
    '${voter.page}'.toJS,
  ).toDart;
  return shared.toDart;
}
