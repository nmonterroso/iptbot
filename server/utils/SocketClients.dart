part of core;

class SocketClients {
	static final _instance = new SocketClients._();
	static final CLOSED_STATES = [WebSocket.CLOSED, WebSocket.CLOSING];
	static final TYPE_AVAILABLE = 'torrents_available';

	List sockets;

	factory SocketClients() => _instance;
	SocketClients._() {
		sockets = [];
	}

	handle(WebSocket socket) {
		socket
			.map((string) => JSON.decode(string))
			.listen((json) {
				var index = sockets.indexOf(socket);
			}, onError: (error) {
			}, onDone: () {
				bool removed = sockets.remove(socket);
			}
		);

		if (CLOSED_STATES.indexOf(socket.readyState) == -1) {
			sockets.add(socket);
		}
	}

	send(WebSocket socket, String type, dynamic message) {
		var data = {
			'method': type,
			'args': message
		};

		socket.add(JSON.encode(data));
	}

	broadcast(String type, dynamic message) {
		for (var socket in sockets) {
			send(socket, type, message);
		}
	}
}