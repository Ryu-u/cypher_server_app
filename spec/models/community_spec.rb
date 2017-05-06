require 'rails_helper'

describe Community do
  before do
    @community = create(:community)
  end

  it 'name column should not be null' do
    expect{@community.update(name: nil)}.to raise_error
  end

  it 'home column should not be null' do
    expect{@community.update(home: nil)}.to raise_error
  end

  it 'bio column should not be null' do
    expect{@community.update(bio: nil)}.to raise_error
  end
end