#= require searcher
#= require results_view

window.twearch or= {}
window.twearch.application or= {}

router = Backbone.Router.extend {
  initialize: ->
    @route(/^$/, 'clear')
    @route(/^(.+?)$/, 'search')
    if window.location.hash
      @search(decodeURIComponent(window.location.hash.replace('#', '')))
    else
      @clear()

  clear: ->
    window.twearch.application.views.searcher.set('')
    window.twearch.application.models.results.search(null)

  search: (q) ->
    window.twearch.application.views.searcher.set(q)
    window.twearch.application.models.results.search(q)
}

jQuery ->
  Backbone.history.start()
  window.twearch.application.router = new router