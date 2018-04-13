module Dependencies
  class Parser
    def parse_job_list(list)
      job_line = list.split("\n")
      job_line.inject(''){|acc,job| acc + job[0]}
    end
  end
end
