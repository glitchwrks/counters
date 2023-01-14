require 'spec_helper'

RSpec.describe CollisionMaker do
  
  let(:hit_touch_five_times) do
    begin
      CollisionMaker.touch
    rescue ActiveRecord::RecordNotUnique
      4.times { CollisionMaker.touch }
    end
  end

  before(:each) do
    CollisionMaker.reset!
  end

  describe '#new_record?' do
    it { expect(CollisionMaker.new_record?).to be_falsey }
  end

  describe 'class method #touch' do
    it 'should raise an error the first time, but not successive times' do
      expect { CollisionMaker.touch }.to raise_error(ActiveRecord::RecordNotUnique)
      expect(CollisionMaker.touch).to eq 'It retried'
      expect(CollisionMaker.touch).to eq 'It retried'
    end

    it 'should increment the invocation count' do
      expect(CollisionMaker.invocation_count).to eq 0
      hit_touch_five_times
      expect(CollisionMaker.invocation_count).to eq 5
    end

    it 'should set the raised error flag' do
      expect(CollisionMaker.raised_error?).to be_falsey
      hit_touch_five_times
      expect(CollisionMaker.raised_error?).to be_truthy
    end
  end

  describe 'class method #reset!' do
    it 'should clear the invocation count' do
      hit_touch_five_times
      expect(CollisionMaker.invocation_count).to eq 5
      CollisionMaker.reset!
      expect(CollisionMaker.invocation_count).to eq 0
    end

    it 'should clear the raised error flag' do
      hit_touch_five_times
      expect(CollisionMaker.raised_error?).to be_truthy
      CollisionMaker.reset!
      expect(CollisionMaker.raised_error?).to be_falsey
    end
  end
end
