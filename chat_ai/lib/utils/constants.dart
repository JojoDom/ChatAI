// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String get API_KEY {
  final env = dotenv.get("CHAT_GPT_API_KEY");
  return env;
}

