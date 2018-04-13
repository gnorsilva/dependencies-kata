module Dependencies
  class Parser
    def parse_job_list(list)
      list.size > 0 ? list[0] : ''
    end
  end
end
