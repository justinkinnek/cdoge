namespace :db do
  task :seed_fake => :environment do
    file_to_load        = Rails.root + "db/seed/config_admin.yml"
    config_information  = YAML::load( File.open( file_to_load ) )
    config_information.each do |table|
      tables_model = table[0].singularize.camelcase.constantize
      table[1].each_pair do |num, attribute_hash|
        puts [num, tables_model.to_s].join(' | ')
        tables_model.create( attribute_hash['attributes'])
      end
    end
  end
end