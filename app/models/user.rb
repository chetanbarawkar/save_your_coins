class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,:recoverable, :rememberable, :trackable, :validatable

  has_many :categories
  has_many :transactions

	validates :email, 
            :uniqueness=> true,
            :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i },
            :presence =>true 
	validates :user_name, 
            :presence => true
end
