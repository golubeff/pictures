class PicturesController < InheritedResources::Base
  http_basic_authenticate_with :name => USERNAME, :password => PASSWORD, :except => :next
  before_filter :load_pictures, :only => :next
  before_filter :error_404, :only => :next
  #caches_page :next

  def next
  end

  protected
  def error_404
    render :action => "error_404" if @pictures.empty?
  end

  def load_pictures
    conditions = ""
    if params[:smallest_id] && params[:highest_id]
      conditions = [ "id > ? or id < ?", params[:highest_id], params[:smallest_id] ]
    end
    @pictures = Picture.find(:all,
                 :conditions => conditions,
                 :order => "id desc", 
                 :limit => 25
                )

  end

  def collection
    @pictures = Picture.paginate(:page => params[:page], :per_page => 10,
                                :order => "id desc")
  end
end
