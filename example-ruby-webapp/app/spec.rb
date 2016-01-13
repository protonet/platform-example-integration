ENV['RACK_ENV'] = 'test'
require './app'

RSpec.describe App do
  include Rack::Test::Methods
  let(:app) { App }

  let(:url) { "http://fake-response.appspot.com/?sleep=2" }
  let(:cache_key) { Digest::SHA1.hexdigest url }

  let(:redis) { double("Redis") }

  before(:each) do
    # Mock out our Redis client
    allow(Redis).to receive(:new).and_return(redis)
  end

  it "queries the HTTP endpoint when not cached, storing it in cache" do
    expect(HTTPClient).to receive(:get).with(url).and_return(double("response", body: 'The Response'))
    expect(redis).to receive(:get).with(cache_key).and_return(nil)
    expect(redis).to receive(:set).with(cache_key, 'The Response')
    expect(redis).to receive(:expire).with(cache_key, 30)

    get '/'
    expect(last_response.body).to be == 'The Response'
  end

  it "uses the cached value and does not query HTTP when cached" do
    expect(HTTPClient).not_to receive(:get)
    expect(redis).to receive(:get).with(cache_key).and_return('Cached Response')
    
    get '/'
    expect(last_response.body).to be == 'Cached Response'
  end
end