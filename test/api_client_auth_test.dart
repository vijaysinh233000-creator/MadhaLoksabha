import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:voter_finder/core/services/api_client.dart';

void main() {
  test('admin requests use the current session token', () async {
    var token = 'session-one';
    final authorizationHeaders = <String?>[];
    final client = MockClient((request) async {
      authorizationHeaders.add(
        request.headers['authorization'] ?? request.headers['Authorization'],
      );
      return http.Response(
        jsonEncode({'villages': [], 'unassigned_pdfs': 0}),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final api = ApiClient(
      baseUrl: 'https://api.example.test',
      client: client,
      accessTokenProvider: () async => token,
    );

    await api.adminVillages();
    token = 'session-two';
    await api.adminVillages();

    expect(authorizationHeaders, ['Bearer session-one', 'Bearer session-two']);
    client.close();
  });

  test('PDF upload sends the current admin session token', () async {
    String? authorizationHeader;
    final client = MockClient((request) async {
      authorizationHeader =
          request.headers['authorization'] ?? request.headers['Authorization'];
      return http.Response(
        jsonEncode({'saved': [], 'errors': []}),
        200,
        headers: {'content-type': 'application/json'},
      );
    });
    final api = ApiClient(
      baseUrl: 'https://api.example.test',
      client: client,
      accessTokenProvider: () async => 'upload-session',
    );

    await api.uploadPdfs([(name: 'roll.pdf', bytes: Uint8List(0))]);

    expect(authorizationHeader, 'Bearer upload-session');
    client.close();
  });
}
