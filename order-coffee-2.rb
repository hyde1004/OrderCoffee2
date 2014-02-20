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

post '/' do
	n = Order.new
	n.name = params[:name]
	n.beverage = params[:beverage]
	n.created_at = Time.now
	n.updated_at = Time.now
	n.save
	redirect '/'
end

get '/:id' do
	@order = Order.get params[:id]
	@title = '#{@order.name} 음료 변경'
	erb :edit
end

put '/:id' do
	n = Order.get params[:id]
	n.beverage = params[:beverage]
	n.updated_at = Time.now
	n.save
	redirect '/'
end

get '/:id/delete' do
	@order = Order.get params[:id]
	@title = "음료 취소 확인"
	erb :delete
end

delete '/:id' do
	n = Order.get params[:id]
	n.destroy
	redirect '/'
end