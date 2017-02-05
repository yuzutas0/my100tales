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
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  has_many :search_conditions, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_many :tales, dependent: :destroy
  has_many :backups, dependent: :destroy

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :name, presence: true, length: { minimum: 1, maximum: 255 }
  validates :timezone, presence: true, inclusion: { in: TZInfo::Timezone.all_identifiers }
end
