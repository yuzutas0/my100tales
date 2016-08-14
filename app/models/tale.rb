#
# Tale
#
class Tale < ActiveRecord::Base
  # -----------------------------------------------------------------
  # relation
  # -----------------------------------------------------------------
  belongs_to :user
  has_many :sequels, dependent: :destroy
  has_and_belongs_to_many :tags

  # -----------------------------------------------------------------
  # routing path (tales/:id => tales/:view_number)
  # -----------------------------------------------------------------
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
  # property
  index_name "es_my100tales_tale_#{Rails.env}"
  # connect
  __elasticsearch__.client = Elasticsearch::Client.new host: Rails.application.secrets.elastic_search_host
end
