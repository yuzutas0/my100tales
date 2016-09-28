#
# User
#
class User < ActiveRecord::Base
  # -----------------------------------------------------------------
  # devise
  # -----------------------------------------------------------------
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  has_many :tales, dependent: :destroy

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
end
