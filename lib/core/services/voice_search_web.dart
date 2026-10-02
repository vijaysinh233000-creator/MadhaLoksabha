import 'dart:js_interop';

@JS('startMarathiVoiceSearch')
external JSPromise<JSString?> _startMarathiVoiceSearch();

Future<String?> startMarathiVoiceSearch() async {
  final value = await _startMarathiVoiceSearch().toDart;
  return value?.toDart;
}
