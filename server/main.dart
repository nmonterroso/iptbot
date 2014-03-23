import 'server/__init.dart';
import 'service/__init.dart';

void main() {
	IptBot bot = new IptBot()..start();
	Server server = new Server()..start();
}