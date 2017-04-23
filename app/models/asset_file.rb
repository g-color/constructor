class AssetFile < ApplicationRecord

  has_attached_file :data, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :data, content_type: //


  def image?
    self.data_content_type.index('image').present?
  end

end
