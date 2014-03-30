require.config({
	paths: {
		angular: 'vendor/angular',
		config: 'config',
		lodash: 'vendor/lodash.min',
		settings: 'components/settings',

		// angular add-ons
		'angular-route': 'vendor/angular-route',

		// jquery
		jquery: 'vendor/jquery-2.1.0.min',
		'jquery.timeago': 'vendor/jquery.timeago'
	},
	shim: {
		angular: {
			exports: 'angular'
		},
		'jquery.timeago': ['jquery'],
		'angular-route': ['angular']
	},
	priority: [
		'angular'
	]
});