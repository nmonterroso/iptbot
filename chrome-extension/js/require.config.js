require.config({
	paths: {
		angular: 'vendor/angular.min',
		config: 'config',
		lodash: 'vendor/lodash.min',
		settings: 'components/settings',

		// jquery
		jquery: 'vendor/jquery-2.1.0.min',
		'jquery.timeago': 'vendor/jquery.timeago'
	},
	shim: {
		angular: {
			exports: 'angular'
		},
		'jquery.timeago': ['jquery']
	},
	priority: [
		'angular'
	]
});