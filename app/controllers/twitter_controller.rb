#!/bin/env ruby
# encoding: utf-8

class TwitterController < ApplicationController

  def search
    # I don't expect this to occur, but handle anyways ...
    if params[:q].blank?
      render :json => { :error => 'Please enter a search term.'}
      return
    end
    query = params[:q]
    search_params = params.delete_if{|k,v| !%w(max_id include_entities since_id).include?(k) }

    opts = { :count => 15 }.merge(search_params)

    results = Twitter.search(query, opts)
    #Rails.logger.debug results.inspect
    render :json => results.to_json
  end

  #def user
    #query = params[:q]
    #search_params = params.delete_if{|k,v| !%w(max_id include_entities since_id geocode).include?(k) }

    #opts = { :count => 15 }.merge(search_params)

    #user_hash = Twitter.user(query).to_hash
    #render :json => user_hash.to_json
  #end

  #def index
    #@messages = search
    #respond_to do |format|
      #format.html
      #format.csv { send_data @messages.to_csv } do
        #response.headers['Content-Type'] = 'text/csv; charset=UTF-8; header=present'
        #response.headers['Content-Disposition'] = 'attachment; filename=Time.now.csv'
      #end
      #format.xls (send_data @messages.to_csv(col_sep: '\t'))
   #end
  #end
end
