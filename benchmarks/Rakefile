require 'rake/clean'

BENCHMARKS = %w{ spawn spawn-multicore }

def run(task = nil)
  BENCHMARKS.each do |dir|
    chdir(dir) { sh "rake #{task}" }
  end  
end

desc 'Clean all intermediate files'
task :clean_all => :clobber do
  run(:clobber)
end

desc 'Run all benchmarks'
task :default do
  run
end

