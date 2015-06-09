
# A simple extension to Hash to add symbolification of hash keys.
#
# Note: Since this gem doesn't require Rails, we cannot rely on those
#       constructs.  We could use the Hashie gem, but that seems like
#       a lot of overhead for a such a simple operation.  Additionally
#       I've seen conflicts with Hashie versions (e.g. Rocketpants only
#       works with Hashie < 3 and those versions of Hashie don't contain
#       the needed symbolize_keys method).
class Hash

  # Recursively (through Hash and Array) converts all Hash keys to symbols (calling to_sym) and returns
  # a duplicate hash.
  def symbolize_hash_keys
    Hash.sym_hash_keys(self)
  end

  private

  def self.sym_hash_keys(value)
    if !value.nil? && value.is_a?(Hash)
      Hash[value.map {|(k,v)| [k.to_sym, Hash.sym_hash_keys(v)]}]
    elsif !value.nil? && value.is_a?(Array)
      value.map { |v| Hash.sym_hash_keys(v) }
    else
      value
    end
  end

end