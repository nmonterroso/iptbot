part of core;

class TorrentData {
	static final RegExp _sizeRegex = new RegExp(r'([0-9\.]+) (MB|GB)$');
	static final RegExp _idRegex = new RegExp(r'iptorrents.com/download.php/([0-9]+)/');
	static final RegExp _tvEpisodeRegex = new RegExp(r's([0-9 ]+)e([0-9]+)', caseSensitive: false);

	static const double KB_TO_GB = 1.074e+9;
	static const double KB_TO_MB = 1.049e+6;

	int _subId, _torrentId, _season, _episode;
	String _title, _link, _date;
	double _size;

	void set date(String date) {
		_date = date;
	}

	void set size(String size) {
		Match m = _sizeRegex.firstMatch(size);

		if (m == null) {
			throw "unable to parse size: ${size}";
		}

		double base = double.parse(m[1]); // in bytes
		double multiplier;

		switch (m[2].toLowerCase()) {
			case 'mb':
				multiplier = KB_TO_MB;
				break;
			case 'gb':
				multiplier = KB_TO_GB;
				break;
		}

		_size = base*multiplier;
	}
	
	void set title(String title) {
		List<int> details = getSeasonAndEpisode(title);
		
		_title = title;
		_season = details[0];
		_episode = details[1];
	}

	void set link(String link) {
		Match m = _idRegex.firstMatch(link);

		_torrentId = int.parse(m[1]);
		_link = link;
	}

	String get friendlySize {
		if (_size > KB_TO_GB) {
			return (_size / KB_TO_GB).toStringAsFixed(2)+" GB";
		}

		return (_size / KB_TO_MB).toStringAsFixed(2)+" MB";
	}
	
	String get title => _title;
	int get torrentId => _torrentId;
	
	static List<int> getSeasonAndEpisode(String title) {
		Match m = _tvEpisodeRegex.firstMatch(title);
		
		if (m == null) {
			throw "unable to parse season/episode data from ${title}";
		}
		
		return [int.parse(m[1].trim()), int.parse(m[2])];
	}
}