require 'spec_helper'

RSpec.describe CollisionMaker do
  let!(:cm) { CollisionMaker.new }
  
  let(:hit_touch_five_times) do
    begin
      cm.touch
    rescue ActiveRecord::RecordNotUnique
      4.times { cm.touch }
    end
  end

  describe '#new_record?' do
    it { expect(cm).not_to be_new_record }
  end

  describe 'class method #touch' do
    it 'should raise an error the first time, but not successive times' do
      expect { cm.touch }.to raise_error(ActiveRecord::RecordNotUnique)
      expect { cm.touch }.not_to raise_error
    end

    it 'should return the CollisionMaker instance after the first time' do
      expect { cm.touch }.to raise_error(ActiveRecord::RecordNotUnique)
      expect(cm.touch.class).to eq CollisionMaker
      expect(cm.touch).to eq cm
    end

    it 'should increment the invocation count' do
      expect(cm.invocation_count).to eq 0
      hit_touch_five_times
      expect(cm.invocation_count).to eq 5
    end

    it 'should set the raised error flag' do
      expect(cm.raised_error).to be_falsey
      hit_touch_five_times
      expect(cm.raised_error).to be_truthy
    end
  end

  describe 'class method #reset!' do
    it 'should clear the invocation count' do
      hit_touch_five_times
      expect(cm.invocation_count).to eq 5
      cm.reset!
      expect(cm.invocation_count).to eq 0
    end

    it 'should clear the raised error flag' do
      hit_touch_five_times
      expect(cm.raised_error).to be_truthy
      cm.reset!
      expect(cm.raised_error).to be_falsey
    end
  end
end
