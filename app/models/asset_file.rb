class AssetFile < ApplicationRecord

  has_attached_file :data, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :data, content_type: //


  def image?
    data_content_type.index(/jpg|png|jpeg/).present?
  end
end
