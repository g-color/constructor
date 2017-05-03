module AuditsHelper
  def get_record(id, type)
    if type == 'Budget' || type == 'ConstructorObject'
      if type == 'Budget'
        Estimate.with_deleted.find(id) if Estimate.with_deleted.exists?(id: id)
        Solution.with_deleted.find(id) if Solution.with_deleted.exists?(id: id)
      else
        Primitive.with_deleted.find(id) if Primitive.with_deleted.exists?(id: id)
        Composite.with_deleted.find(id) if Composite.with_deleted.exists?(id: id)
      end
    else
      clazz = type.constantize
      clazz.with_deleted.find(id)
    end
  end

  def get_record_name(id, type)
    record = get_record(id, type)
    record.to_s
  end

  def get_record_link(id, type)
    record = get_record(id, type)
    record&.link
  end
end
