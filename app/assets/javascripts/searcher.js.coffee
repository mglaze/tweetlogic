
window.twearch or= {}
window.twearch.application or= {}
window.twearch.application.views or= {}

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
    window.twearch.application.router.navigate(safeQuery, true)
    false # block form POST

  preventClose: (e) ->
    e.stopPropagation()
    true

  setLocation: (loc) ->
    @geolocation = loc
    window.twearch.application.models.results.setLocation(@geolocation)

    @$el.find('.btn.disabled').removeClass('disabled')
    @

  geolocationChanged: ->
    if @$el.find('#geolocation').val() != ''
      # set geolocation on model
      window.twearch.application.models.results.setProximity(@$el.find('#geolocation').val())
    else
      # clear geolocation on model
      window.twearch.application.models.results.setProximity(null)

    @

  events: 
    'submit form': 'search'
    'click .dropdown-menu': 'preventClose'
    'change #geolocation': 'geolocationChanged'
}

jQuery ->
  window.twearch.application.views.searcher = new searcher
  # drive geolocation
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition((loc) ->
      window.twearch.application.views.searcher.setLocation(loc)
    )