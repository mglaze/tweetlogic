#!/bin/env ruby
# encoding: utf-8

class TwitterController < ApplicationController

  def search # search for tweets with query
    if params[:q].blank?
      render :json => { :error => 'Please enter a search term.'}
      return
    end
    query = params[:q]
    search_params = params.delete_if{|k,v| !%w(max_id include_entities since_id).include?(k) }

    opts = { :count => 15 }.merge(search_params)

    @results = Twitter.search(query, opts)

    render :json => @results.to_json
  end

  def data # transform the API data into a hash in the format I want(TwitterAPI = JSON)
    @results.statuses.map { |status|
      {
        :user => status[:user][:name],
        :date => status[:created_at],
        :text => status[:text],
        :location => status[:location]
      }
    }
  end
  def to_csv(data)
    CSV.generate do |csv|
      csv << data[0].keys.map{|k| k.to_s.capitalize}
      data.each do |tweet|
        csv << tweet.values
      end
    end
  end
end