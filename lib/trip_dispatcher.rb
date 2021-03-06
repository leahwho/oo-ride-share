require 'csv'
require 'time'

require_relative 'driver'
require_relative 'passenger'
require_relative 'trip'

module RideShare
  class TripDispatcher
    attr_reader :drivers, :passengers, :trips
    
    def initialize(directory: './support')
      @passengers = Passenger.load_all(directory: directory)
      @trips = Trip.load_all(directory: directory)
      @drivers = Driver.load_all(directory: directory)
      connect_trips
    end
    
    def find_passenger(id)
      Passenger.validate_id(id)
      return @passengers.find { |passenger| passenger.id == id }
    end
    
    def find_driver(id)
      Driver.validate_id(id)
      return @drivers.find { |driver| driver.id == id }
    end
    
    def find_available_driver
      # finds next :AVAILABLE driver for a new trip
      available_driver = @drivers.select { |driver| driver.status == :AVAILABLE }[0]
      
      return available_driver
    end

    def sort_trips_by_id
      # sorts trips by ID in order to add a new ID to a new trip
      sorted = @trips.sort_by { |trip| trip.id }

      return sorted 
    end
    
    def request_trip(passenger_id)
      @driver = find_available_driver
      @passenger = find_passenger(passenger_id)

      sorted_by_id = sort_trips_by_id

      new_trip = RideShare::Trip.new(
        id: sorted_by_id.last.id + 1,
        driver: @driver,
        passenger: @passenger,
        start_time: Time.now,
        rating: nil 
      )
      
      connect_trip(new_trip)
      
      @trips << new_trip
      
      @driver.modify_status
      
      return new_trip
    end
    
    def inspect
      # Make puts output more useful
      return "#<#{self.class.name}:0x#{object_id.to_s(16)} \
      #{trips.count} trips, \
      #{drivers.count} drivers, \
      #{passengers.count} passengers>"
    end
    
    private
    
    def connect_trip(trip)
      # adds a new trip to passenger and driver
      trip.connect(trip.passenger, trip.driver)
    end
    
    def connect_trips
      @trips.each do |trip| 
        passenger = find_passenger(trip.passenger_id) 
        driver = find_driver(trip.driver_id)
        trip.connect(passenger, driver)
      end
      
      return trips
    end
  end
end