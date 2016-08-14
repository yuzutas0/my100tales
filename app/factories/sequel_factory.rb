# sequel_factory
class SequelFactory
  # -----------------------------------------------------------------
  # Create
  # -----------------------------------------------------------------

  # use transaction to save record if you call this method
  # in order to make combination of tale_id and view_number unique
  def self.instance(params, tale)
    sequel = tale.sequels.build(params)
    sequel.view_number = increment_view_number(tale.id)
    sequel
  end

  private

  # support method
  def self.increment_view_number(tale_id)
    last = Sequel.where('tale_id = ?', tale_id).maximum(:view_number)
    last.present? ? last + 1 : 1
  end
end
