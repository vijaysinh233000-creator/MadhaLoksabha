import 'dart:js_interop';
import 'dart:convert';

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

@JS('shareVoterCards')
external JSPromise<JSBoolean> _shareVoterCards(JSString votersJson);

Future<bool> shareVoterCards(List<VoterResult> voters) async {
  final payload = voters
      .map(
        (voter) => {
          'name': voter.name,
          'relationLabel': voter.relationLabel,
          'relationName': voter.relationName,
          'village': voter.village,
          'serial': voter.serial,
          'part': voter.part,
          'epic': voter.epic,
          'house': voter.house,
          'age': voter.age,
          'gender': voter.gender,
          'page': '${voter.page}',
        },
      )
      .toList();
  final shared = await _shareVoterCards(jsonEncode(payload).toJS).toDart;
  return shared.toDart;
}
