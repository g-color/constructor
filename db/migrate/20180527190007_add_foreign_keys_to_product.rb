class AddForeignKeysToProduct < ActiveRecord::Migration[5.1]
  def change
    add_reference :product_templates, :product, null: true
    add_reference :product_sets, :product, null: true

    ProductTemplateSet.all.each do |pts|
      ProductSet.find(pts.product_set_id).update(product_id: pts.product_id)
      ProductTemplate.find(pts.product_template_id).update(product_id: pts.product_id)
    end
  end
end
