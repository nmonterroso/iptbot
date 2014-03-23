library server;

// core library
import 'dart:io';
import 'dart:async';
import 'dart:mirrors';
import 'dart:convert';

// pubspec
import 'package:http_server/http_server.dart';
import 'package:route/server.dart';
import 'package:route/url_pattern.dart';

// other libraries
import '../lib/__init.dart';

// components
part 'Server.dart';
part 'api/handlers/PostHandler.dart';
part 'api/handlers/GetHandler.dart';
part 'Handler.dart';
part 'DefaultHandler.dart';

// api
part 'api/ApiBase.dart';
part 'api/handlers/ApiHandler.dart';
part 'api/ApiResponse.dart';
part 'api/TorrentApi.dart';