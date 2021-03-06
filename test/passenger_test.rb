require_relative 'test_helper'

describe "Passenger class" do
  
  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    end
    
    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end
    
    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::Passenger.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end
    
    it "sets trips to an empty array if not provided" do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end
    
    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@passenger).must_respond_to prop
      end
      
      expect(@passenger.id).must_be_kind_of Integer
      expect(@passenger.name).must_be_kind_of String
      expect(@passenger.phone_number).must_be_kind_of String
      expect(@passenger.trips).must_be_kind_of Array
    end
  end
  
  
  describe "trips property" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        driver_id: 4,
        start_time: Time.new(2016, 8, 8, 14, 33, 20),
        end_time: Time.new(2016, 8, 9, 15, 33, 20),
        cost: 15,
        rating: 5
      )
      @passenger.add_trip(trip)
    end
    
    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end
    
    it "all Trips must have the same passenger's passenger id" do
      @passenger.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
  end
  
  
  describe "net_expenditures" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      trip = RideShare::Trip.new(
        id: 66,
        passenger: @passenger,
        driver_id: 5,
        start_time: Time.new(2018, 12, 30, 14, 33, 20),
        end_time: Time.new(2018, 12, 31, 15, 33, 20),
        cost: 17,
        rating: 5
      )
      @passenger.add_trip(trip)
      trip2 = RideShare::Trip.new(
        id: 66,
        passenger: @passenger,
        driver_id: 5,
        start_time: Time.new(2018, 12, 30, 14, 33, 20),
        end_time: Time.new(2018, 12, 31, 15, 33, 20),
        cost: 10,
        rating: 5
      )
      @passenger.add_trip(trip2)
    end
    
    it "calculates net_expenditures" do
      expect(@passenger.net_expenditures).must_equal 27
    end
  end 
  
  
  describe "net_expenditures with in-progress trips" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      trip = RideShare::Trip.new(
        id: 66,
        passenger: @passenger,
        driver_id: 5,
        start_time: Time.new(2018, 12, 30, 14, 33, 20),
        end_time: Time.new(2018, 12, 31, 15, 33, 20),
        cost: 17,
        rating: 5
      )
      @passenger.add_trip(trip)
      trip2 = RideShare::Trip.new(
        id: 66,
        passenger: @passenger,
        driver_id: 5,
        start_time: Time.new(2018, 12, 30, 14, 33, 20),
        end_time: nil,
        cost: nil,
        rating: nil
      )
      @passenger.add_trip(trip2)
    end
    
    it "calculates net_expenditures, ignoring nill values for cost" do
      expect(@passenger.net_expenditures).must_equal 17
    end
  end
  
  
  describe "total_time_spent with in-progress trips" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      trip = RideShare::Trip.new(
        id: 66,
        passenger: @passenger,
        driver_id: 5,
        start_time: Time.new(2018, 12, 30, 14, 33, 20),
        end_time: Time.new(2018, 12, 30, 15, 33, 20),
        cost: 17,
        rating: 5
      )
      @passenger.add_trip(trip)
      trip2 = RideShare::Trip.new(
        id: 66,
        passenger: @passenger,
        driver_id: 5,
        start_time: Time.new(2018, 12, 30, 14, 33, 20),
        end_time: nil,
        cost: nil,
        rating: nil
      )
      @passenger.add_trip(trip2)
    end
    
    it "calculates total_time_spent, ignoring nill values for end_time" do
      expect(@passenger.total_time_spent).must_equal 3600
    end
  end
  
  
  describe "net_expenditures no trips" do
    
    before do 
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
    end
    
    it "accounts for no trips" do
      expect(@passenger.net_expenditures).must_be_nil
    end
  end
  
  
  describe "trip_duration" do
    
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      
      trip = RideShare::Trip.new(
        id: 66,
        passenger: @passenger,
        driver_id: 10,
        start_time: Time.new(2018, 12, 30, 14, 33, 20),
        end_time: Time.new(2018, 12, 30, 15, 33, 20),
        cost: 17,
        rating: 5
      )
      @passenger.add_trip(trip)
      
      trip2 = RideShare::Trip.new(
        id: 67,
        passenger: @passenger,
        driver_id: 5,
        start_time: Time.new(2018, 12, 30, 17, 50, 20),
        end_time: Time.new(2018, 12, 30, 18, 50, 20),
        cost: 15,
        rating: 5
      )
      @passenger.add_trip(trip2)
    end
    
    it "calculates trip duration" do
      expect(@passenger.total_time_spent).must_equal 7200
    end
  end
  
  
  describe "total_time no trips" do
    
    before do 
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
    end
    
    it "accounts for total_time with no trips" do
      expect(@passenger.total_time_spent).must_be_nil
    end
  end
end 
