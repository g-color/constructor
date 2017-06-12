class ConstructorObjectsController < ApplicationController
  autocomplete :constructor_object, :name, scopes: [:active], :full => true, :extra_data => [:type], :display_value => :autocomplete_name

  def info
    constructor_object = ConstructorObject.find(params[:id])
    ajax_ok(
      name: constructor_object.name,
      unit: constructor_object.unit.name
    )
  end

  def get_autocomplete_items(parameters)
    ids = params[:ids].blank? ? [] : params[:ids].split(',').map(&:to_i)
    super(parameters).where.not(id: ids)
  end
end
