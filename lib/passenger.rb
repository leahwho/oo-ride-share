require_relative 'csv_record'

module RideShare
  class Passenger < CsvRecord
    attr_reader :name, :phone_number, :trips

    def initialize(id:, name:, phone_number:, trips: nil)
      super(id)

      @name = name
      @phone_number = phone_number
      @trips = trips || []
    end

    def add_trip(trip)
      @trips << trip
    end

    def net_expenditures
      @trips.delete_if { |trip| trip.cost == nil }

      if @trips.empty? || @trips == nil 
        return nil
      else
      return @trips.map { |trip| trip.cost }.sum
      end 
    end

    def total_time_spent
      @trips.delete_if { |trip| trip.end_time == nil }

      if @trips.empty? || @trips == nil 
        return nil
      else
        duration = @trips.map { |trip| trip.trip_duration }.sum
      end
      return duration
    end


    private

    def self.from_csv(record)
      return new(
        id: record[:id],
        name: record[:name],
        phone_number: record[:phone_num]
      )
    end
  end
end
