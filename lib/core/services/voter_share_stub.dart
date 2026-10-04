import '../models/models.dart';

Future<bool> shareVoterCard(VoterResult voter) async => false;

Future<bool> shareVoterCards(List<VoterResult> voters) async => false;

Future<bool> downloadDuplicateReport(
  String title,
  String basis,
  String verifiedAt,
  List<DuplicateGroup> groups,
) async => false;
