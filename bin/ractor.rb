require 'bundler/setup'
require_relative '../config/environment'
require 'dotenv'
require 'tastyworks/apex'
require 'async'
require 'async/http/internet'
Dotenv.load


urls = [
  'https://uat-api.apexclearing.com/ale/api/v1/read/sentinel2-batch/TWTT?limit=1000&highWaterMark=148856092&sinceDateTime=2023-01-13&streamType=LONG_POLL&timeoutSeconds=10',
  'https://uat-api.apexclearing.com/ale/api/v1/read/sentinel2-batch/TWTT?limit=1000&highWaterMark=148856092&sinceDateTime=2023-01-13&streamType=LONG_POLL&timeoutSeconds=5',
  'https://uat-api.apexclearing.com/ale/api/v1/read/sentinel2-batch/TWTT?limit=1000&highWaterMark=148856092&sinceDateTime=2023-01-13&streamType=LONG_POLL&timeoutSeconds=2'
]


# for each url, create a ractor for each url
# each ractor will request the url and print the response
# loop and select from ractors, print the ractor that has finished and send a new request to the ractor



Tw::Apex::Ale::AccountRequestStatusMessage.partition_payloads
def create_ractor(token, url)
  Ractor.new(token, url) do |auth_token, foo|
    headers = { 'Authorization' => auth_token, 'Content-Type' => 'application/json' }
    Tw::Apex::Ale::AccountRequestStatusMessage.partition_payloads
  end
end

ractors = urls.map do |url|
  token = Tw::Apex::Http::JsonClient.fetch_token
  ractor = create_ractor(token, url)

  ractor.send(url)
end

loop do
  ractor = Ractor.select(*ractors)

  p ractor
  p ractor.inspect
end