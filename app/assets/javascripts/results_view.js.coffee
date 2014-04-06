#= require results_model

window.TweetLogic or= {}
window.TweetLogic.application or= {}
window.TweetLogic.application.views or= {}
window.TweetLogic.application.models or= {}

results = Backbone.View.extend {
  el: 'section[role=results]'
  model: window.TweetLogic.application.models.results
  content: null
  resultsTemplate: null

  initialize: ->
    @content = @$el.find('.content')
    @resultsTemplate = Mustache.compile(@$el.find('#search_results').html())
    @model.on('sync', @render, @)
    @model.on('searching', @loading, @)
    @model.on('reset', @render, @)

    @render()
    @

  loading: ->
    @content.html(@$el.find('#loading').html())
    @

  no_results: ->
    # either no results because there's truly no results, or there's no query ...
    if @model.query && @model.query != ''
      @content.html(@$el.find('#no_results').html())
    else
      @content.html(@$el.find('#no_search').html())
    @

  render: ->
    if !@model.models or @model.models.length == 0
      @no_results()
      return @

    _.each(@model.models, (item) ->
      item.attributes.class_name = if item.get('new') then 'new' else ''
    )
    output = @resultsTemplate({ tweets: @model.toJSON() })
    @content.html(output)

    if @model.next_results
      @content.append(@$el.find('#loading').html())

      self = @

      loading = @content.find('.loading')
      loading.appear()
      loading.on('appear', () ->
        loading.off('appear')
        self.model.more()
      )
    else
      @content.append(@$el.find('#no_more_results').html())

    @content.find('.new').appear().on('appear', () ->
      $(@).removeClass('new')
      $(@).off('appear')
    )
    @
}

jQuery ->
  window.TweetLogic.application.views.results = new results
  