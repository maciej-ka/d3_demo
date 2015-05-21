controllers = angular.module 'controllers'
controllers.controller 'RolesController', ['$scope', '$routeParams', 'Role', '$state'
  ($scope, $routeParams, Role, $state) ->
    $scope.load = ->
      $scope.roles = Role.all()

    $scope.new = ->
      $scope.role = null
      $state.go 'roles.new'

    $scope.edit = (role) ->
      $state.go('roles.edit', id: role.id)
        .then -> $scope.role = angular.copy(role)

    $scope.save = (role) ->
      $scope.roles.save(role)
      $state.go 'roles'

    $scope.delete = (role) ->
      $scope.roles.delete(role)
      $state.go 'roles'

    $scope.load()
]