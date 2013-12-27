part of iptservice;

class Parser {
	static final Parser _instance = new Parser._();

	XmlElementHelper _helper = new XmlElementHelper();

	factory Parser() => _instance;
	Parser._();

	void parse(String data) {
		XmlElement xml = XML.parse(data);
		XmlCollection<XmlNode> items = xml.queryAll('item');

		items.forEach((XmlElement item) {
			IptData data = _helper.extractData(item);
		});
	}
}
