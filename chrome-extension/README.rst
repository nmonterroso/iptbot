================
Chrome Extension
================

This part provides a frontend for interacting with the server and service provided in ../server.

Installation
------------
Until I get around to publishing this on the chrome webstore, the only way to install is to follow the instructions provided by Google on manually packaging extensions (https://developer.chrome.com/extensions/packaging), and then to drag the generated .crx to the chrome://extensions page.

Usage
-----
Once installed, use the torrents page in the extension pop-up to manage torrents, and the subscriptions page to view your current subscriptions. To add a new subscription, fill out the form at the top:

1. name - this is what the service will use to filter incoming torrents on the iptorrents RSS feed.
2. file system location - where to check for currently existing files. iptbot will try to prevent notifying you of files you already have