#= require searcher
#= require results_view

window.TweetLogic or= {}
window.TweetLogic.application or= {}

router = Backbone.Router.extend {
  initialize: ->
    @route(/^$/, 'clear')
    @route(/^(.+?)$/, 'search')
    if window.location.hash
      @search(decodeURIComponent(window.location.hash.replace('#', '')))
    else
      @clear()

  clear: ->
    window.TweetLogic.application.views.searcher.set('')
    window.TweetLogic.application.models.results.search(null)

  search: (q) ->
    window.TweetLogic.application.views.searcher.set(q)
    window.TweetLogic.application.models.results.search(q)
}

jQuery ->
  Backbone.history.start()
  window.TweetLogic.application.router = new router