# loop and sleep for 1 millisecond
# use tastyworks-apex to retrieve ale messages
# convert ale messages to http requests

require 'bundler/setup'
require_relative '../config/environment'
require 'dotenv'
Dotenv.load

require 'tastyworks/apex'
require 'async'

def work
  Tw::Apex::Ale::AccountRequestStatusMessage.partition_payloads.each do |message|
    base_url = TwApi::Http::UrlBuilder.new(TwApi::Http::Config.base_url).append('apex').append('account-request-status').to_s
    TwApi::Http::JsonClient.patch(base_url, {
      requestId: message.request_id,
      status: message.status
    }) do |response|
      p response
    end
  end
end
# typhoeus doesn't work well with fiber scheduler, requests are blocking


require 'async/http/internet'
TwApi::Http::Util.authorization_token = "twucs-apex-message-relay-elixir-token+S"

def request_tasty
  headers = { 'Authorization' => 'twucs-apex-message-relay-elixir-token+S', 'Content-Type' => 'application/json' }
  Async do
    internet = Async::HTTP::Internet.new
    1.times.each do
      p internet.get('https://api.tastyworks.com/account-types', headers).read
      p internet.get('https://staging-api.tastyworks.com').read
      p 'hello'
    end
  end
end

Async do

end
internet = Async::HTTP::Internet.new

def fetch_topic
  internet = Async::HTTP::Internet.new
  headers = { 'Authorization' => Tw::Apex::Http::JsonClient.fetch_token, 'Content-Type' => 'application/json' }
  Async do
    loop do
      p 'run foo'
      p internet.get('https://uat-api.apexclearing.com/ale/api/v1/read/sentinel2-batch/TWTT?limit=1000&highWaterMark=149399444&sinceDateTime=2023-01-13&streamType=LONG_POLL&timeoutSeconds=10', headers).read
      p 'foo'
      sleep 1
    end
  end
end

def fetch_other_topic
  internet = Async::HTTP::Internet.new
  headers = { 'Authorization' => Tw::Apex::Http::JsonClient.fetch_token, 'Content-Type' => 'application/json' }
  Async do
    loop do
      p 'run bar'
      p internet.get('https://uat-api.apexclearing.com/ale/api/v1/read/sentinel2-batch/TWTT?limit=1000&highWaterMark=149399444&sinceDateTime=2023-01-13&streamType=LONG_POLL&timeoutSeconds=5', headers).read
      p 'bar'
      sleep 1
    end
  end
end

def run_relay
  loop do
    Async do
      fetch_topic
      fetch_other_topic
      sleep 1
    end
  end
end

run_relay


Async do
  loop do
    Async do
      loop do
        p 'run world'
        p internet.get('https://uat-api.apexclearing.com/ale/api/v1/read/sentinel2-batch/TWTT?limit=1000&highWaterMark=148856092&sinceDateTime=2023-01-13&streamType=LONG_POLL&timeoutSeconds=10', headers).read
        url = 'https://uat-api.apexclearing.com/ale/api/v1/read/sentinel2-batch/TWTT'
        data = {
          'limit' => 1000,
          'highWaterMark' =>  148856092,
          'sinceDateTime' => '2023-01-13',
          'streamType' => 'LONG_POLL'
        }

        uri = URI(url)
        uri.query = URI.encode_www_form(data)

        # p internet.get(url, headers, JSON.dump(data)).read
        p 'world'
      end
      sleep 1
    end

    Async do
      loop do
        p 'run bar'
        p internet.get('https://uat-api.apexclearing.com/ale/api/v1/read/sentinel2-batch/TWTT?limit=1000&highWaterMark=148856092&sinceDateTime=2023-01-13&streamType=LONG_POLL&timeoutSeconds=5', headers).read
        p 'bar'
        sleep 1
      end
    end
    sleep 1
  end
end
