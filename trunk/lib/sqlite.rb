
require 'sqlite3'

db = SQLite3::Database.new("database.sqlite")
db.execute( "select * from uboj" ) do |row|
  p row
end
db.close
