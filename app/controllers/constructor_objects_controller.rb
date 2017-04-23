class ConstructorObjectsController < ApplicationController
  autocomplete :constructor_object, :name

  def info
    constructor_object = ConstructorObject.find(params[:id])
    ajax_ok(
      name: constructor_object.name,
      unit: constructor_object.unit.name
    )
  end

end
