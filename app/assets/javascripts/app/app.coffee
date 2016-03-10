@application = angular.module('commits',
  [ 'ui.router',
    'ui-notification',
    'ngResource',
    'angular-loading-bar',
    'angular-confirm',
    'ui.bootstrap',
    'angularUtils.directives.dirPagination',
    'angularMoment'])

@application.config ['$httpProvider', '$stateProvider', '$urlRouterProvider', 'NotificationProvider', ($httpProvider, $stateProvider, $urlRouterProvider, NotificationProvider) ->

  NotificationProvider.setOptions({
    delay: 3000,
    startTop: 20,
    startRight: 10,
    verticalSpacing: 20,
    horizontalSpacing: 20,
    positionX: 'right',
    positionY: 'top'
  })

  $httpProvider.defaults.useXDomain = true
  $httpProvider.defaults.headers.post['Content-Type']= 'application/json'
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
  $httpProvider.interceptors.push 'AlertsMonitor'
  delete $httpProvider.defaults.headers.common['X-Requested-With']

  $stateProvider
  .state 'commits',
    url: '/',
    templateUrl: '/templates/commits/index.html',
    controller: 'CommitsController',
    controllerAs: 'vm',
    resolve:
      Commits: ['Resources', (Resources) ->
        Resources '/commits', {id: @id}, [
          {method: 'GET', isArray: false},
          {name: 'parse', method: 'POST', url: '/parse', isArray: false}
          {name: 'update_author', method: 'POST', url: '/update_author', isArray: false}
        ]
      ]

  $urlRouterProvider.otherwise '/'

  return
]
