part of core;

class XmlElementHelper {
	TorrentData extractData(XmlElement e) {
		TorrentData data = new TorrentData();
		XmlElement child;
		XmlText text;

		for (int i = 0; i < e.children.length; ++i) {
			child = e.children[i];

			if (child.children.length == 1 && child.children[0] is XmlText) {
				text = child.children[0];

				switch (child.name) {
					case 'title':
						data.title = text.text;
						break;
					case 'link':
						data.link = text.text;
						break;
					case 'pubDate':
						data.date = text.text;
						break;
					case 'description':
						data.size = text.text;
						break;
					default:
						continue;
				}
			}
		}

		return data;
	}
}