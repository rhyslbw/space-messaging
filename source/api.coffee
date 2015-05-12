
class Space.messaging.Api extends Space.Object

  Dependencies:
    eventBus: 'Space.messaging.EventBus'
    commandBus: 'Space.messaging.CommandBus'

  @_methodHandlers: null

  # Register a handler for a Meteor method and add it as
  # method to instance to simplify testing of methods.
  @method: (name, handler) ->

    handlers = @_methodHandlers ?= {}
    handlers[name] = original: handler, bound: null

    # Register the method statically, so that is done only once
    method = {}
    method[name] = ->
      # Provide the method context to bound handler
      args = [this].concat Array::slice.call(arguments)
      handlers[name].bound.apply null, args
    Meteor.methods method

  onDependenciesReady: ->
    handlers = @constructor._methodHandlers
    for methodName, handler of handlers
      boundHandler = _.bind handler.original, this
      handlers[methodName].bound = @[methodName] = boundHandler