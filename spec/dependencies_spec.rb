require 'dependencies'

RSpec.describe Dependencies::Parser do

  it 'should parse an empty sequence for an empty job list' do
    expect(subject.parse_job_list('')).to eq ''
  end

  it 'should parse a single job sequence for a single job list' do
    expect(subject.parse_job_list('a =>')).to eq 'a'
  end

  it 'should parse a multiple job sequence with no dependencies' do
    jobs = <<~JOBS
      a =>
      b =>
      c =>
    JOBS

    expect(subject.parse_job_list(jobs)).to eq 'abc'
  end

end
