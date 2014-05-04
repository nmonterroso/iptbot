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
				updateBadge(data.args);
				break;
			default:
				console.log("unsupported operation: "+data.method);
				break;
		}
	};

	function updateBadge(count) {
		var displayCount = count;

		if (typeof count == "number") {
			displayCount = count > 0 ? count+'' : '';
		}

		chrome.browserAction.setBadgeText({text: displayCount});
	}
})();