class PicturesController < InheritedResources::Base
  http_basic_authenticate_with :name => USERNAME, :password => PASSWORD, :except => :next
  before_filter :load_pictures, :only => :next
  before_filter :error_404, :only => :next
  caches_page :next

  def next
  end

  protected
  def error_404
    render :action => "error_404" if @pictures.empty?
  end

  def load_pictures
    @pictures = Picture.find(:all, 
                 :conditions => [ "id > ?", params[:id] ], 
                 :order => "id",
                 :limit => 25
                )

  end
end
