class PStoreAdapter < SimpleDelegator
  def []=(key, value)
    self.transaction do
      super
    end
  end

  def [](key)
    self.transaction do
      super
    end
  end

  def delete(key)
    self.transaction do
      super
    end
  end

  def keys
    self.transaction(true) do
      roots
    end
  end
end
