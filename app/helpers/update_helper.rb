module UpdateHelper

  def last_updated_at
    res = ActiveRecord::Base.connection.execute('select last_updated_at from updates')
    res[0]['last_updated_at']
  end

  def last_updated_at=(new_timestamp)
    ActiveRecord::Base.connection.execute("update updates set last_updated_at = '#{new_timestamp}' where last_updated_at = '#{self.last_updated_at}'")
  end
end