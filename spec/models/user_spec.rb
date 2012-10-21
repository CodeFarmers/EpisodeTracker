require 'spec_helper'

describe User do
  before { @user = User.new(:email => "john.doe@gmail.com", :password => "123", :password_confirmation => "123", :remember_me => true) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_me) }
end
