(function(){
	var host = chrome.runtime.getManifest().permissions[0].replace('http', 'ws')+'socket';
	var socket = new WebSocket(host);

	socket.onerror = function() {
		console.log("unable to connect to "+host);
	};

	socket.onmessage = function(event) {
		if (!event.data) {
			console.log("no data!");
		}

		var data = JSON.parse(event.data);
		switch (data.method) {
			case 'torrents_available':
				updateBadge(parseInt(data.args));
				break;
			case 'torrent_count_update':
				chrome.browserAction.getBadgeText({}, function(text) {
					var newCount;

					if (text == '') {
						newCount = parseInt(data.args);
					} else {
						newCount = parseInt(text) + parseInt(data.args);
					}

					updateBadge(newCount);
				});
				break;
			default:
				console.log("unsupported operation: "+data.method);
				break;
		}
	};

	function updateBadge(count) {
		displayCount = count > 0 ? count.toString() : '';
		chrome.browserAction.setBadgeText({text: displayCount});
	}
})();