class CommitsController
  constructor: (@rootScope, @scope, @Commits, @confirm, @Alerts) ->
    vm = @
    vm.items_limit = 50
    vm.eEditable = -1
    vm.filter =
      email: undefined
    vm.parse =
      user: ''
      repo: ''


    @scope.$watch('vm.parse.user', (old_val, new_val) ->
      if new_val.length > 0
        vm.Commits.find_user_repos({user: vm.parse.user}).$promise.then( (response) ->
          if response.success
            vm.parse.repos = response.repos
        )
    )
    
    @fetch_commits()


  fetch_commits: ->
    vm = @
    @Commits.query().$promise.then( (commits) ->
      vm.commits = commits
    )

  update_author: (commit) ->
    vm = @
    vm.eEditable = -1

    author =
      id: commit.user_id
      name: commit.name

    vm.Commits.update_author(commit: author).$promise.then( (response) ->
      console.log response
    )

  name_changed: (commit) ->
    vm = @
    t_commit.name = commit.name for t_commit in vm.commits when t_commit.user_id is commit.user_id
    return

  import: ->
    vm = @

    return @Alerts.error 'You should fill user' if not vm.parse.user.length > 0
    return @Alerts.error 'You should fill repo name' if not vm.parse.repo.length > 0

    @Alerts.success 'Query sended..'
    vm.Commits.parse(vm.parse).$promise.then( (commits) ->
      vm.fetch_commits() if commits.success
    )

  import_confirm: ->
    vm = @
    vm.confirm(text: 'previous data will be deleted').then ->
      vm.import()

@application.controller 'CommitsController', ['$rootScope', '$scope', 'Commits', '$confirm', 'Alerts', CommitsController]
