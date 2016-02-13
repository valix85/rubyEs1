class Content < ActiveRecord::Base
	belongs_to :user
	
	has_attached_file :cover, styles: { medium: "300x>", thumb: "100x>" } 
    validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/
end
