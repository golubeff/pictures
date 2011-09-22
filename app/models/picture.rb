class Picture < ActiveRecord::Base
  after_save :download_image
  after_destroy :unlink_image

  def directory
    path(:thumb).gsub(/\/[^\/]+$/, '')
  end

  def path(type)
    "#{Rails.root}/public#{self.uri(type)}"
  end

  def uri(type)
    "/system/pictures/#{self.id}/#{self.id}_#{type}.png"
  end

  protected
  def download_image
    `wget #{self.source_url} -O /tmp/picture_#{self.id}`
    FileUtils.mkpath(directory)
    `convert /tmp/picture_#{self.id} -resize 128x128 #{path(:thumb)}`
    `convert /tmp/picture_#{self.id} -resize 512x512 #{path(:full)}`
  end

  def unlink_image
    FileUtils.rmtree(directory)
  end
end
