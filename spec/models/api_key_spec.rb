require 'rails_helper'

RSpec.describe ApiKey, type: :model do
  describe 'with DB' do
    context 'not null constraint' do
      it {have_not_null_constraint_on(:user_id)}
      it {have_not_null_constraint_on(:access_token)}
      it {have_not_null_constraint_on(:firebase_uid)}
    end

    context 'of uniqueness' do
      it 'should not have the same value　in access_token columns in different records' do
        expect do
          user = create(:user, :with_api_key)
          another_api_key = ApiKey.new(firebase_uid: user.api_keys.first.firebase_uid)
          user.api_keys << another_api_key
          another_api_key.save!(validate: false)
          another_api_key.update_attribute(:access_token,
                                           user.api_keys.first.access_token)
        end.to raise_error( ActiveRecord::RecordNotUnique )
      end
    end
  end

  describe 'with model' do
    context 'association' do
      it {is_expected.to belong_to(:user)}
    end
  end
end
