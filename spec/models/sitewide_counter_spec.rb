require 'spec_helper'

RSpec.describe SitewideCounter, :type => :model do

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

  describe '#ipv4_hit_count' do

    it { expect(FactoryBot.build(:sitewide_counter).ipv4_hit_count).to eq 0 }

    describe 'on a SitewideCounter with preload' do
      let(:sitewide_counter_with_hits) { FactoryBot.create(:sitewide_counter, :ipv4_preload => 1) }

      it { expect(sitewide_counter_with_hits.ipv4_hit_count).to eq 1 }

      describe 'when other Hits exist' do
        let!(:counter_with_many_hits) { FactoryBot.create(:counter_with_many_hits) }

        it { expect(sitewide_counter_with_hits.ipv4_hit_count).to eq 26 }
        it { expect(sitewide_counter_with_hits.ipv6_hit_count).to eq 25 }
      end
    end
  end

  describe '#ipv6_hit_count' do

    it { expect(FactoryBot.build(:sitewide_counter).ipv6_hit_count).to eq 0 }

    describe 'on a SitewideCounter with preload' do
      let(:sitewide_counter_with_hits) { FactoryBot.create(:sitewide_counter, :ipv6_preload => 1) }

      it { expect(sitewide_counter_with_hits.ipv6_hit_count).to eq 1 }

      describe 'when other Hits exist' do
        let!(:counter_with_many_hits) { FactoryBot.create(:counter_with_many_hits) }

        it { expect(sitewide_counter_with_hits.ipv4_hit_count).to eq 25 }
        it { expect(sitewide_counter_with_hits.ipv6_hit_count).to eq 26 }
      end
    end
  end

end
