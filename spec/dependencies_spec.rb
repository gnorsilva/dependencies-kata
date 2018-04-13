require 'dependencies'

RSpec.describe Dependencies::Parser do

  it 'should parse an empty sequence for an empty job list' do
    expect(subject.parse_job_list('')).to eq ''
  end

end
