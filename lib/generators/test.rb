stty_settings = %x[stty -g]
print 'Password: '

begin
  %x[stty -echo]
  password = gets
ensure
  %x[stty #{stty_settings}]
end

puts

print 'regular info: '
regular_info = gets

puts "password: #{password}"
puts "regular:  #{regular_info}"