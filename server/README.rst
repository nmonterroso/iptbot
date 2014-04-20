======
Server
======
This part of the project should probably be renamed. This houses both the "server" and the "service" portion of iptbot. These are written in the Dart (https://www.dartlang.org/) programming language, so you'll need to set that up and run pub get to install the dependencies.

The server portion is responsible for acting as an HTTP server. It provides a REST API for managing torrent subscriptions and for acting on torrents (downloading and dismissing).

The service is a worker that sleeps and parses the iptorrents RSS feed defined in the config. If a torrent matches, its data is saved for display in the chrome extension (TODO: automatic downloading?)

Running
-------
To run the server/service, first set up the required config files (see Config and BTC below), and then
run main.dart through the Dart SDK executable, for example::

    dart.exe --package-root=<path>/server/packages/ <path>/server/main.dart

Running as a Service
--------------------
Under windows, check out http://nssm.cc/. Under Linux/Mac systems, you should be able to google around for running a command as a daemon or service.

Config
======
The main config file needed to run the server/service portions is held in utils/config/config.json. For reference, see utils/config/config.example.json for the fields and value types.

BTC
===
iptbot uses BTC (https://github.com/bittorrent/btc) to talk to utorrent (currently the only supported torrent client). Please see BTC's github page for instructions on setting it up. Once BTC is set up, the only requirements are to add the full path to the BTC executable in config.json (btcLocation) and to add a btc.conf to utils/config