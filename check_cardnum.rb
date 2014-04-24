require 'sinatra'
require 'haml'

get '/' do
	haml :ask
end

get '/verify-card-num' do
	haml :ask
end

post '/verify-result' do
	f = params[:res]
	f.chomp('"').reverse.chomp('"').reverse
	#f.add("f")
	array2 = f.to_s.split(//).map(&:to_i)

	co = isLuhnValid(array2)
	@result = co
	haml :result
end

get '/card/*/verify' do 
  
n = params[:splat]
array = n.to_s.split(//).map(&:to_i)
#"This Credit Card has #{isLuhnValid(array)} check digit!"
@result = isLuhnValid(array)
haml :result
end

def luhnCheckSum(a)
	odds =  a.reverse.values_at(* a.each_index.select {|i| i.even?})
	even =   a.reverse.values_at(* a.each_index.select {|i| i.odd?})
	checksum = 0
	checksum = odds.inject(0) {|sum, i|  sum + i }
	even.map!{|d| checksum += (d*2).to_s.split('').map(&:to_i).inject(0) {|sum,f| sum +f}}
	return checksum % 10
	end

def isLuhnValid(a)
	return luhnCheckSum(a) == 0
end 