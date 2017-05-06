require 'rails_helper'

describe User do
  before do
    @user = create(:user)
  end

  it 'name column should be not null' do
    expect{@user.update(name: nil)}.to raise_error
  end

  it 'home column should be not null' do
    expect{@user.home(home: nil)}.to raise_error
  end

  it 'bio column should be not null' do
    expect{@user.home(bio: nil)}.to raise_error
  end

  it 'type_flag column should be not null' do
    expect{@user.home(type_flag: nil)}.to raise_error
  end

end