require 'spec_helper'

describe Episode do

  it { should belong_to(:series) }
  it { should validate_presence_of(:name) }

end
