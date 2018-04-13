module Dependencies
  class Parser
    def parse_job_list(list)
      job_lines  = list.split("\n")
      tree = Tree.new
      map_lines_to_tree(job_lines, tree)
      tree.job_sequence
    end

    def map_lines_to_tree(job_lines, tree)
      job_lines.each do |line|
        left, right = line.split(' =>').map(&:strip)

        if right
          tree.add_dependency(left, right)
        else
          tree.add_independent(left)
        end
      end
    end
  end

  class Tree

    def initialize
      @acc = ''
    end

    def add_dependency(downstream, upstream)
      @acc << upstream << downstream
    end

    def add_independent(independent)
      unless @acc.include?(independent)
        @acc << independent
      end
    end

    def job_sequence
      @acc
    end
  end
end
