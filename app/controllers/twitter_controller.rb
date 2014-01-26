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
    search_params = params.delete_if{|k,v| !%w(max_id include_entities since_id geocode).include?(k) }

    opts = { :count => 15 }.merge(search_params)

    results = Twitter.search(query, opts)
    # Rails.logger.debug results.inspect
    render :json => results.to_json
  end

  def user_mentions
    if params[:l].blank?
      render :json => { :error => 'Please enter a username.'}
      return
    end
    @user_mentions ||= entities(Twitter::Entity::UserMention, :user_mentions)
  end
end
