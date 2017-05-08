module AuditsHelper
  def self.get_action(audit)
    get_auditable(audit)
    return 'Изменение' if ObjectClassName.subclasses.has_key?(@auditable.class.to_s)
    AuditAction.fetch(audit.action)
  end

  def self.get_class(audit)
    get_auditable(audit)

    if ObjectClassName.subclasses.include?(@auditable.class.to_s)
      ObjectClassName.subclasses.fetch(@auditable.class.to_s, @auditable.class.to_s)
    else
      ObjectClassName.fetch(@auditable.class.to_s)
    end
  end

  def self.get_auditable(audit)
    @auditable = audit.auditable
    if @auditable.nil?
      @auditable = audit.auditable_type.constantize.with_deleted.find(audit.auditable_id)
    end
    @auditable
  end
end
