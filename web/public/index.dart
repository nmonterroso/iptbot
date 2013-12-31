library public;

// core
import 'dart:convert';

// pubspec
import 'package:angular/angular.dart';

// other libraries
import '../../lib/__init.dart';

// components
part 'controller/index.dart';

main() => ngBootstrap(module: new IndexModule());

class IndexModule extends Module {
	IndexModule() {
		type(IndexController);
	}
}