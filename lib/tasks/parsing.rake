namespace :parsing do
  desc "Get JSON of BUS!"
  task bus: :environment do
    parser = BusesController.new
    parser.api_test
    parser.api_test2
  end

  task test: :environment do
    parser = BusesController.new
    parser.api_test3
  end
end
