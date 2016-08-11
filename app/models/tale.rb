#
# Tale
#
class Tale < ActiveRecord::Base
  # -----------------------------------------------------------------
  # include
  # -----------------------------------------------------------------
  include TaleSearchable

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
  # Create
  # -----------------------------------------------------------------

  # use transaction to save record if you call this method
  # in order to make combination of user_id and view_number unique
  def self.instance(params, user)
    tale = Tale.new(params)
    tale.user = user
    tale.view_number = get_view_number(user.id)
    tale
  end

  # support method
  def self.get_view_number(user_id)
    last = Tale.where('user_id = ?', user_id).maximum(:view_number)
    last.present? ? last + 1 : 1
  end

  # create index for ElasticSearch
  def self.create_index
    __elasticsearch__.client = Elasticsearch::Client.new host: Rails.application.secrets.elastic_search_host
    create_index! force: true
    __elasticsearch__.import
  end

  # import data to Elasticsearch
  def self.import_index
    __elasticsearch__.client = Elasticsearch::Client.new host: Rails.application.secrets.elastic_search_host
    __elasticsearch__.import
  end

  # -----------------------------------------------------------------
  # Read - index
  # -----------------------------------------------------------------

  # main
  def self.read(user_id, queries)
    if queries.keyword.present?
      begin
        Tale.search_by_es(queries.keyword, queries.page)
      rescue
        Tale.search_by_db(user_id, queries.keyword, queries.page)
      end
    else
      Tale.list(user_id, queries.page)
    end
  end

  # get index by MariaDB
  def self.list(user_id, page)
    Tale.where('user_id = ?', user_id).page(page).per(10).order(updated_at: :desc)
  end

  # search by MariaDB
  def self.search_by_db(user_id, keyword, page)
    keyword = '%' + keyword + '%'
    Tale.where('user_id = ? AND (title LIKE ? OR content LIKE ?)', user_id, keyword, keyword).page(page).per(10).order(updated_at: :desc)
  end

  # search by Elasticsearch
  # FIXME
  def self.search_by_es(query, page)
    search(query).page(page).per(10).order(updated_at: :desc).records
  end

  # -----------------------------------------------------------------
  # Read - detail
  # -----------------------------------------------------------------
  def self.detail(view_number, user_id)
    Tale.where('view_number = ? AND user_id = ?', view_number, user_id).first
  end
end
