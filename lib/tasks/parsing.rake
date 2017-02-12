namespace :parsing do
  desc "Get JSON of BUS!"
  task bus: :environment do
    parser = BusesController.new
    parser.api
  end
end
