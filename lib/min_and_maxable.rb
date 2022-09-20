module MinAndMaxable
  def key_at_min(hash)
    hash.key(hash.values.min)
  end

  def key_at_max(hash)
    hash.key(hash.values.max)
  end
end
