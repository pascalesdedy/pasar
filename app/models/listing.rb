class Listing < ActiveRecord::Base
    
    if Rails.env.development?
        
        has_attached_file   :image, :styles => { :medium => "300x", :thumb => "100x" }, 
                            :default_url => "default.jpg",
                            :convert_options => {:medium => '-background white -gravity center -extent 200x200'}
                            validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
    else
        
        
        
        has_attached_file   :image, :styles => { :medium => "300x", :thumb => "100x" }, :default_url => "default.jpg", 
                            :storage => :dropbox,
                            :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
                            :path => ":style/:id_:filename"
                            validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
    end

        validates :name, :description, :price, presence: true
        validates :price, numericality: { greater_than: 0 }
        validates_attachment_presence :image
        
        belongs_to :user

    def previous
         Listing.where(["id < ?", id]).last
    end

    def next
        Listing.where(["id > ?", id]).first
    end

end