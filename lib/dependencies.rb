module Dependencies

  class Parser
    def parse_job_list(list)
      job_lines = list.split("\n")
      tree = Tree.new
      map_lines_to_tree(job_lines, tree)
      tree.job_sequence
    end

    def map_lines_to_tree(job_lines, tree)
      job_lines.each do |line|
        left, right = line.split(' =>').map(&:strip)

        if left == right
          raise 'A job cannot depend on itself'
        elsif right
          tree.add_dependency(left, right)
        else
          tree.add_independent(left)
        end
      end
    end
  end

  class Tree

    def initialize
      @jobs = {}
      @independent_jobs = {}
    end

    def add_dependency(downstream, upstream)
      upstream_job = @jobs.fetch(upstream) {|key| @jobs[key] = Job.new(upstream)}
      downstream_job = @jobs.fetch(downstream) {|key| @jobs[key] = Job.new(downstream)}

      if cyclical_dependency?(downstream_job, upstream_job)
        raise 'Cyclical dependency'
      end

      if downstream_job.independent?
        @independent_jobs.delete(downstream)
      end

      upstream_job.add_dependency(downstream_job)

      if upstream_job.independent?
        @independent_jobs[upstream] = upstream_job
      end
    end

    def add_independent(independent)
      unless @independent_jobs[independent]
        job = Job.new(independent)
        @jobs[independent] = job
        @independent_jobs[independent] = job
      end
    end

    def job_sequence
      traverse_jobs(@independent_jobs.values)
    end

    private

    def cyclical_dependency?(downstream_job, upstream_job)
      if not upstream_job
        false
      elsif downstream_job == upstream_job
        true
      else
        cyclical_dependency?(downstream_job, upstream_job.upstream)
      end
    end

    def traverse_jobs(jobs)
      jobs.inject('') do |acc, job|
        acc + job.name + traverse_jobs(job.dependencies)
      end
    end
  end

  class Job
    attr_reader :name
    attr_reader :dependencies
    attr_reader :upstream

    def initialize(name)
      @name = name
      @dependencies = []
      @upstream = nil
    end

    def add_dependency(downstream_job)
      @dependencies << downstream_job
      downstream_job.upstream = self
    end

    def independent?
      @upstream.nil?
    end

    protected

    attr_writer :upstream
  end
end
