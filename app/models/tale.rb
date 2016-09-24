#
# Tale
#
class Tale < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :user
  has_many :sequels, dependent: :destroy
  has_many :tale_tag_relationships, dependent: :destroy
  has_many :tags, through: :tale_tag_relationships

  # -----------------------------------------------------------------
  # routing path (tales/:id => tales/:view_number)
  # -----------------------------------------------------------------
  # needs two params with request
  # user.id, tale.view_number
  # (user.id + tale.view_number => tale.id)
  def to_param
    view_number.to_s
  end

  # -----------------------------------------------------------------
  # validation
  # -----------------------------------------------------------------
  validates :user, presence: true
  validates :title, presence: true
  validates :content, presence: true, length: { maximum: 15_000 }

  # -----------------------------------------------------------------
  # elasticsearch
  # -----------------------------------------------------------------
  # include
  include TaleSearchable
  include TaleFinder
  # connect
  index_name TaleSearchable::INDEX_NAME
  __elasticsearch__.client = TaleSearchable::CLIENT
end
