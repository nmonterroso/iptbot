require.config({
	paths: {
		config: 'config',
		settings: 'components/settings',
		angular: 'vendor/angular',
		lodash: 'vendor/lodash.min'
	},
	shim: {
		angular: {
			exports: 'angular'
		}
	},
	priority: [
		'angular'
	]
});