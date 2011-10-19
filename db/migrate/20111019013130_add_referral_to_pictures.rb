class AddReferralToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :referral_url, :string
  end
end
