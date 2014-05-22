module Hashie
  class Mash

    def pick(*args)
      args = args.map {|v| v.to_s}
      Hashie::Mash.new Hash[*self.select {|k,v| args.include?(k)}.flatten]
    end

  end
end
