class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :omniauthable
  include DeviseTokenAuth::Concerns::User

  has_many :teams_users,  :dependent => :delete_all
  has_many :teams, through: :teams_users

  has_many :group_user
  has_many :groups, through: :group_user
end
