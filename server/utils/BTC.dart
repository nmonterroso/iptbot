part of core;

class BTC {
	static final BTC _instance = new BTC._();
	static const CONFIG_PATH = '/utils/config/btc.conf';

	factory BTC() => _instance;
	BTC._();

	Future<Map> start(TorrentData torrent) {
		Config config = new Config();
		Map<String, String> environment = {
			'BTC_CONFIG_FILE': Directory.current.path+CONFIG_PATH
		};

		return
			Process.run(config.btc, ['add', '--url', torrent.link], environment: environment)
			.then((ProcessResult p) {
				if (p.exitCode != 0) {
					print(p.stderr);
					return null;
				}

				return JSON.decode(p.stdout);
			});
	}
}
