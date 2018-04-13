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

  it 'should parse a multiple job sequence with one dependency' do
    jobs = <<~JOBS
      a =>
      b => c
      c =>
    JOBS

    expect(subject.parse_job_list(jobs)).to eq 'acb'
  end

  it 'should parse a multiple job sequence with multiple dependencies' do
    jobs = <<~JOBS
      a =>
      b => c
      c => f
      d => a
      e => b
      f =>
    JOBS

    expect(subject.parse_job_list(jobs)).to eq 'adfcbe'
  end

  it 'should raise an error when a job depends on itself' do
    jobs = <<~JOBS
      a =>
      b =>
      c => c
    JOBS

    expect {subject.parse_job_list(jobs)}.to raise_error('A job cannot depend on itself')
  end

  it 'should raise an error if there is a cyclical dependency' do
    jobs = <<~JOBS
      a =>
      b => c
      c => f
      d => a
      e =>
      f => b
    JOBS

    expect {subject.parse_job_list(jobs)}.to raise_error('Cyclical dependency')
  end

end
