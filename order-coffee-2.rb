require 'sinatra'
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/order.db")

class Order
	include DataMapper::Resource
	property :id, Serial
	property :name, Text, :required => true
	property :beverage, Text, :required => true
	property :created_at, DateTime
	property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!

get '/' do
	@orders = Order.all :order => :id.desc
	@title = 'All Orders'
	erb :home
end