
window.TweetLogic or= {}
window.TweetLogic.application or= {}
window.TweetLogic.application.views or= {}

searcher = Backbone.View.extend {
  el: 'header',
  geolocation: null,

  initialize: ->
    @

  set: (q) ->
    @$el.find('#query').val(q)
    @

  search: ->
    safeQuery = encodeURIComponent(@$el.find('#query').val())
    window.TweetLogic.application.router.navigate(safeQuery, true)
    false # block form POST

  preventClose: (e) ->
    e.stopPropagation()
    true

  setLocation: (loc) ->
    @geolocation = loc
    window.TweetLogic.application.models.results.setLocation(@geolocation)

    @$el.find('.btn.disabled').removeClass('disabled')
    @

  geolocationChanged: ->
    if @$el.find('#geolocation').val() != ''
      # set geolocation on model
      window.TweetLogic.application.models.results.setProximity(@$el.find('#geolocation').val())
    else
      # clear geolocation on model
      window.TweetLogic.application.models.results.setProximity(null)

    @

  events: 
    'submit form': 'search'
    'click .dropdown-menu': 'preventClose'
    'change #geolocation': 'geolocationChanged'
}

jQuery ->
  window.TweetLogic.application.views.searcher = new searcher
  # drive geolocation
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition((loc) ->
      window.TweetLogic.application.views.searcher.setLocation(loc)
    )