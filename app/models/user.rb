class User < ActiveRecord::Base
  has_many :commits, dependent: :destroy
end
