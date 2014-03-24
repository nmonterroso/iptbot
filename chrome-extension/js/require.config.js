require.config({
	paths: {
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