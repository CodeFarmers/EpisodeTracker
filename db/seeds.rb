# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#


ActiveRecord::Base.connection.execute("insert into updates (last_updated_at) values ('1362939962')")