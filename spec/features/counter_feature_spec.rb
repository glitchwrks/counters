require 'spec_helper'
require 'rack/test'

RSpec.describe 'Counters', :type => :feature do
  include Rack::Test::Methods

  def app
    Counters
  end

  let!(:foo_sitewide_counter) { FactoryBot.create(:sitewide_counter, :name => 'foo', :ipv4_preload => 42) }
  let!(:bar_counter) { FactoryBot.create(:counter_with_hits, :name => 'bar') }

  describe 'when getting a nonexistent Counter' do

    before(:each) do
      get '/counters/baz'
    end

    it { expect(last_response.status).to eq 404 }
    it { expect(last_response.body).to be_empty }
  end

  describe 'when getting a regular Counter' do

    before(:each) do
      get '/counters/bar'
    end

    it { expect(last_response.status).to eq 200 }
    it { expect(last_response.content_type).to eq 'application/javascript;charset=utf-8' }
    it { expect(last_response.body).to eq "document.write('000003');" }
  end

  describe 'when getting a regular Counter IPv6 count' do

    before(:each) do
      get '/counters/bar?ipv6=true'
    end

    it { expect(last_response.status).to eq 200 }

    it { expect(last_response.content_type).to eq 'application/javascript;charset=utf-8' }
    it { expect(last_response.body).to eq "document.write('000003 (000001 on IPv6)');" }
  end

  describe 'when getting a Sitewide Counter' do

    before(:each) do
      get '/counters/foo'
    end

    it { expect(last_response.status).to eq 200 }
    it { expect(last_response.content_type).to eq 'application/javascript;charset=utf-8' }
    it { expect(last_response.body).to eq "document.write('000045');" }
  end
end