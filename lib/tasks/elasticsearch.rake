# lib/tasks/elasticsearch.rake
namespace :elasticsearch do
  desc 'Create index for Elasticsearch'
  task create_index: :environment do
    Tale.create_index
  end

  desc 'Import to Elasticsearch'
  task import: :environment do
    Tale.import_index
  end
end
