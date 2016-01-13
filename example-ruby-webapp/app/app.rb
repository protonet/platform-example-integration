ENV["RACK_ENV"] ||= "development"
require "bundler"
Bundler.require :default, ENV["RACK_ENV"]
require 'digest/sha1'

class App < Sinatra::Base
  helpers do
    # Initializes memoized redis client instance
    def redis
      @redis ||= Redis.new url: ENV["REDIS_URL"]
    end

    # Converts given string into a shorter cache key
    def cache_key(string)
      Digest::SHA1.hexdigest string
    end

    # Try to fetch the given url from redis cache, otherwise request it and store 
    # it in cache for 30 seconds
    def try_cached(url)
      if cached = redis.get(cache_key(url))
        cached
      else
        response_body = HTTPClient.get(url).body
        redis.set cache_key(url), response_body
        redis.expire cache_key(url), 30
        response_body
      end
    end
  end

  get "/" do
    # Fetches response from a slow response fake http web service. Subsequent requests
    # should be fast thanks to our redis cache until the cache key expires.
    try_cached 'http://fake-response.appspot.com/?sleep=2'
  end
end