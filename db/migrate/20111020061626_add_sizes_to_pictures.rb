class AddSizesToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :thumb_width, :integer
    add_column :pictures, :thumb_height, :integer
    add_column :pictures, :full_width, :integer
    add_column :pictures, :full_height, :integer

    Picture.all.each do |picture|
      picture.send(:calculate_sizes!)
    end
  end
end
