
require 'sqlite'

db = SQLite::Database.new( "test.db" )
rows = db.execute("select * from test" )
