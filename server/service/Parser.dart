part of service;

class Parser {
	static final Parser _instance = new Parser._();

	XmlElementHelper _helper = new XmlElementHelper();

	factory Parser() => _instance;
	Parser._();

	Future<List<TorrentData>> parse(String data, DataStorage storage) {
		XmlElement xml;
		XmlCollection<XmlNode> items;
		int newLastSeen;

		try {
			xml = XML.parse(data);
			items = xml.queryAll('item');
		} catch (error) {
			print(error.toString());
			return new Future.value([]);
		}

		return 
			Future.wait([storage.getLastSeen(), storage.getFilters()])
			.then((responses) {
				int lastSeen = responses[0];
				List<TorrentFilter> filters = responses[1];
				List<Future> waitList = [];
				
				for (int i = 0; i < items.length; ++i) {
					XmlElement item = items[i];
					TorrentData data;
					
					try {
						data = _helper.extractData(item);
					} catch (error) {
						print(error.toString());
						continue;
					}
		
					if (data.torrentId == lastSeen) {
						break;
					} else if (newLastSeen == null) {
						newLastSeen = data.torrentId;
					}
		
					filters.forEach((TorrentFilter filter) {
						waitList.add(filter.allow(data));
					});
				}
				
				waitList.add(storage.setLastSeen(newLastSeen));
				return Future.wait(waitList);
			})
			.then((List responses) {
				responses = new List.from(responses)..removeWhere((item) => item == null); // Future.wait() gives ungrowable list
				responses.removeLast(); // remove result of storage.setLastSeen();
				return new Future.value(responses);
			});
	}
}
