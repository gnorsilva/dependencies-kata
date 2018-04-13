module Dependencies
  class Parser
    def parse_job_list(list)
      job_line = list.split("\n")

      job_line.inject('') do |acc, line|
        left, right = line.split(' =>').map(&:strip)

        if right
          acc << right << left
        elsif not acc.include?(left)
          acc << left
        end

        acc
      end
    end
  end
end
