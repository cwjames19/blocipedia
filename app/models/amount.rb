class Amount < ActiveRecord::Base
  @default = 1500

  class << self
    attr_accessor :default
  end
end
