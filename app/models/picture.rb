class Picture < ActiveRecord::Base
  after_save :download_image
  after_save :calculate_sizes
  after_destroy :unlink_image
  validates_presence_of :source_url

  def directory
    path(:thumb).gsub(/\/[^\/]+$/, '')
  end

  def path(type)
    "#{Rails.root}/public#{self.uri(type)}"
  end

  def referral_url
    self.read_attribute('referral_url') || self.source_url
  end

  def uri(type)
    "/system/pictures/#{self.id}/#{self.id}_#{type}.jpg"
  end

  def url(type)
    "http://#{DOMAIN}#{uri(type)}"
  end

  protected
  def download_image
    if self.changes.keys.include?(:source_url)
      `wget #{self.source_url} -O /tmp/picture_#{self.id}`
      FileUtils.mkpath(directory)
      `convert /tmp/picture_#{self.id} -resize 80x80 -quality 61 #{path(:thumb)}`
      `convert /tmp/picture_#{self.id} -resize 768 -quality 61 #{path(:full)}`
    end
    true
  end

  def calculate_sizes
    calculate_sizes! if self.changes.keys.include?(:source_url)
    true
  end

  def calculate_sizes!
    self.thumb_width, self.thumb_height = `identify #{path(:thumb)}`.split(/ /)[2].split('x')
    self.full_width, self.full_height = `identify #{path(:full)}`.split(/ /)[2].split('x')
    self.save!
  end

  def unlink_image
    FileUtils.rmtree(directory)
  end
end
