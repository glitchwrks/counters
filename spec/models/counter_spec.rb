require 'spec_helper'

RSpec.describe Counter, :type => :model do
  let(:counter_with_hits) { FactoryBot.create(:counter_with_hits) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  describe '#ipv4_hit_count' do

    it { expect(FactoryBot.build(:counter).ipv4_hit_count).to eq 0 }
    it { expect(counter_with_hits.ipv4_hit_count).to eq 1 }

    describe 'on a Counter with Hits' do

      it { expect(counter_with_hits.ipv4_hit_count).to eq 1 }

      it 'should increment the hit count when an IPv4 Hit happens' do
        FactoryBot.create(:hit, :counter => counter_with_hits)
        expect(counter_with_hits.ipv6_hit_count).to eq 1
        expect(counter_with_hits.ipv4_hit_count).to eq 2
      end
    end
  end

  describe '#ipv6_hit_count' do

    it { expect(FactoryBot.build(:counter).ipv6_hit_count).to eq 0 }

    describe 'on a Counter with Hits' do

      it { expect(counter_with_hits.ipv6_hit_count).to eq 1 }

      it 'should increment the hit count when an IPv6 Hit happens' do
        FactoryBot.create(:hit, :ipv6, :counter => counter_with_hits)
        expect(counter_with_hits.ipv6_hit_count).to eq 2
        expect(counter_with_hits.ipv4_hit_count).to eq 1
      end
    end
  end

  describe '#javascript_hit_count' do

    it { expect(counter_with_hits.javascript_hit_count).to eq "document.write('000002');" }
    it { expect(counter_with_hits.javascript_hit_count(true)).to eq "document.write('000002 (000001 on IPv6)');" }
  end

  describe '#update_preloads!' do
    let(:counter_with_many_hits) { FactoryBot.create(:counter_with_many_hits) }

    it { expect(counter_with_many_hits.hits.count).to eq 50 }

    describe 'after consolidating the Hits into preloads' do
      
      before(:each) do
        counter_with_many_hits.update_preloads!
      end

      it { expect(counter_with_many_hits.hits.count).to eq 0 }
      it { expect(counter_with_many_hits.ipv4_hit_count).to eq 25 }
      it { expect(counter_with_many_hits.ipv6_hit_count).to eq 25 }
    end
  end

end
