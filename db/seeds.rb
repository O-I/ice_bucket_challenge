seed_file = File.join(Rails.root, 'db', 'bucketeers.yml')
config = YAML::load_file(seed_file)
Bucketeer.create(config['bucketeers'])