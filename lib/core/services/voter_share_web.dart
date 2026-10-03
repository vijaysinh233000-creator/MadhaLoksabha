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

@JS('shareDuplicateVoterList')
external JSPromise<JSBoolean> _shareDuplicateVoterList(
  JSString title,
  JSString groupsJson,
);

Future<bool> shareDuplicateGroups(
  String title,
  List<DuplicateGroup> groups,
) async {
  final payload = groups
      .map(
        (group) => {
          'label': group.label,
          'relationLabel': group.relationLabel,
          'verification': group.verification,
          'reasons': group.reasons,
          'records': group.records
              .map(
                (record) => {
                  'name': record.name,
                  'relationName': record.relationName,
                  'relationType': record.relationType,
                  'village': record.village,
                  'serial': record.serial,
                  'part': record.part,
                  'epic': record.epic,
                  'house': record.house,
                  'age': record.age,
                  'gender': record.gender,
                  'page': record.page,
                  'pdfName': record.pdfName,
                },
              )
              .toList(),
        },
      )
      .toList();
  final shared = await _shareDuplicateVoterList(
    title.toJS,
    jsonEncode(payload).toJS,
  ).toDart;
  return shared.toDart;
}
