class String
  def downcase
    UnicodeUtils.downcase(self)
  end
  def downcase!
    self.replace downcase
  end
  def upcase
    UnicodeUtils.upcase(self)
  end
  def upcase!
    self.replace upcase
  end
end
