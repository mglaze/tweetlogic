
window.TweetLogic or= {}
window.TweetLogic.application or= {}
window.TweetLogic.application.models or= {}

results = Backbone.Collection.extend {
  query: null
  data: null # cached dataset
  next_results: null
  refresh_results: null
  retrieve_more: false
  retrieve_refresh: false
  pending_more: false
  pending_refresh: false
  geolocation: null
  proximity: null
  refresh_timeout: null

  search: (q) ->
    if q && q != ''
      @clear() if @query != q
      @trigger('searching')
      @query = q
      @fetch({reset: true})
    else
      @query = null
      @reset()

  clear: ->
    @clearRefresh()
    @data = null
    Backbone.Collection.prototype.set.apply(this, arguments);

  url: ->
    if @retrieve_more
      @retrieve_more = false
      params = @next_results
    else if @retrieve_refresh
      @retrieve_refresh = false
      params = @refresh_results
    else
      params = { q: @query }
      params.geocode = @geolocation.coords.latitude + ',' + @geolocation.coords.longitude + ',' + @proximity if @geolocation and @proximity
      params = $.param(params)


    url = "/twitter/search?" + params
    url

  setLocation: (loc) ->
    @geolocation = loc
    @

  setProximity: (proximity) ->
    return if proximity == @proximity
    @proximity = proximity

    # update the results if a query's been set
    if @query && @geolocation
      @trigger('searching')
      @fetch()
    @

  error: (m) ->
    @trigger('error', m)
    @

  clearRefresh: ->
    if @refresh_timeout
      clearTimeout(@refresh_timeout)
      @refresh_timeout = null
    @

  more: ->
    @retrieve_more = true
    @pending_more = true
    @fetch()

  refresh: ->
    @clearRefresh()
    @retrieve_refresh = true
    @pending_refresh = true
    @fetch({ reset: true })

  parse: (data) ->
    return [] if !data or !data.statuses    

    if !@pending_more
      @refresh_results = if data.search_metadata.refresh_url then data.search_metadata.refresh_url.replace('?', '') else null
    if !@pending_refresh
      @next_results = if data.search_metadata.next_results then data.search_metadata.next_results.replace('?', '') else null

    # @next_results = data.search_metadata.next_results.replace('?', '') unless @pending_refresh || !data.search_metadata.next_results
    # @refresh_results = data.search_metadata.refresh_url.replace('?', '') unless @pending_more || !data.search_metadata.refresh_url
    

    # refresh the list every minute IF this wasn't a *more* request
    if !@pending_more
      @refresh_timeout = setTimeout(->
        self.refresh()
      , 60 * 1000)

    self = @
    if @pending_refresh
      @pending_refresh = false
      # prepend retrieved results onto current results
      statuses = data.statuses
      _.each(statuses, (item) -> item.new = true)
      _.each(@data.statuses, (item) -> 
        item.new = false # clear
        statuses[statuses.length] = item
      )
      # _data = @data # temp placeholder to hang onto data during clear()
      # @set(null) # wipes data so that we re-render
      # @data = _data
      @data.statuses = statuses
    else if @pending_more
      @pending_more = false
      # append retrieved results onto current results
      _.each(data.statuses, (item) ->
        self.data.statuses[self.data.statuses.length] = item # append item
      )
    else
      # wipe old results and refresh
      @data = data

    # handle time-dist and format links
    _.each(data.statuses, (item) ->
      # format time display -> Wed Aug 27 13:08:45 +0000 2008
      time = moment(item.created_at, "ddd MMM D HH:mm:ss ZZ YYYY")

      if time.isAfter(moment().subtract('minutes', 1))
        item.time_distance = moment().diff(time, 'seconds') + 's'
      else if time.isAfter(moment().subtract('hours', 1))
        item.time_distance = moment().diff(time, 'minutes') + 'm'
      else if time.isAfter(moment().subtract('days', 1))
        item.time_distance = moment().diff(time, 'hours') + 'h'
      else
        item.time_distance = time.format('D MMM')

      return if item._formatted # do not double-format the tweet body though

      # find/format all links within the text
      links = []

      _.each(item.entities.hashtags, (hashtag) ->
        links[links.length] =
          display: '#' + hashtag.text
          url: 'https://twitter.com/search?src=hash&q=%23' + hashtag.text
          indices: hashtag.indices
      )
      _.each(item.entities.symbols, (symbol) ->
        links[links.length] =
          display: '$' + symbol.text
          url: 'https://twitter.com/search?src=ctag&q=%24' + symbol.text
          indices: symbol.indices
      )
      _.each(item.entities.urls, (url) ->
        links[links.length] =
          display: url.display_url
          url: url.url
          indices: url.indices
      )
      _.each(item.entities.user_mentions, (user) ->
        links[links.length] =
          display: '@' + user.screen_name,
          url: 'http://twitter.com/' + user.screen_name,
          indices: user.indices
      )

      links.sort((a, b) ->
        b.indices[0] - a.indices[0]
      )

      # links are now sorted (from last link to first), modify the text of the tweet to insert the links
      _.each(links, (link) ->
        text = item.text
        linkHtml = '<a href="' + link.url + '" target="_twitter">' + link.display + '</a>'
        item.text = text.slice(0, link.indices[0]) + linkHtml + text.slice(link.indices[1])        
      )

      item._formatted = true

      item
    )

    return @data.statuses
}

window.TweetLogic.application.models.results = new results
