require 'spec_helper'
require 'timecop'

RSpec.describe Hit, :type => :model do

  it { is_expected.to validate_presence_of :address }
  it { is_expected.to validate_uniqueness_of(:address).case_insensitive.scoped_to(:counter_id) }

  describe 'class method #process_hit' do
    let(:mock_request) { mock() }
    let!(:counter) { FactoryBot.create(:counter) }
    let(:processed_hit) { counter.hits.first }

    describe 'new Hit with an IPv4 address' do

      before(:each) do
        mock_request.expects(:ip).returns('1.2.3.4').twice
        Hit.process_hit(mock_request, counter)
      end

      it { expect(counter.hits.count).to eq 1 }
      it { expect(processed_hit.address).to eq '1.2.3.4' }
      it { expect(processed_hit).not_to be_ipv6 }
      it { expect(processed_hit.created_at.round).to eq processed_hit.updated_at.round }
    end

    describe 'new Hit with an IPv6 address' do

      before(:each) do
        mock_request.expects(:ip).returns('2001:db8:1::1').twice
        Hit.process_hit(mock_request, counter)
      end

      it { expect(counter.hits.count).to eq 1 }
      it { expect(processed_hit.address).to eq '2001:db8:1::1' }
      it { expect(processed_hit).to be_ipv6 }
      it { expect(processed_hit.created_at.round).to eq processed_hit.updated_at.round }
    end

    describe 'when a Hit already exists for the address' do

      before(:each) do
        Timecop.freeze(1.day.ago) do
          FactoryBot.create(:hit, :ipv6, :address => '2001:db8:1::1', :counter => counter)
        end

        mock_request.expects(:ip).returns('2001:db8:1::1').twice
        Hit.process_hit(mock_request, counter)
      end

      it { expect(counter.hits.count).to eq 1 }
      it { expect(processed_hit.updated_at).to be > processed_hit.created_at }

      describe 'collision that results in a RecordNotUnique error' do
        let!(:hit_double) { CollisionMaker.new }

        it 'should try again' do
          expect(Hit.process_hit(mock_request, counter, hit_double)).to eq hit_double
          expect(hit_double.invocation_count).to eq 2
          expect(hit_double.raised_error).to be_truthy
        end
      end
    end

    describe 'optional Hit dependency injection' do
      let(:mock_hit) { mock(:hit) }

      it 'should allow a Hit to be passed in' do
        mock_hit.expects(:new_record?).returns(true)
        mock_request.expects(:ip).never
        Hit.process_hit(mock_request, counter, mock_hit)
      end
    end
  end
end
