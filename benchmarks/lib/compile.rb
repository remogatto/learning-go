def erlang_compile(fn)
  sh "erlc #{fn}.erl"
end

def erlang_run(prog, args = [])
  puts command = "erl -noshell -pa #{Dir.pwd} -s #{prog} start #{args.shift} -s init stop #{args.join(' ')}"
  IO.popen(command) do |pipe|
    yield pipe.gets
  end
end

def go_compile(prog)
  sh "#{GO_COMPILER} #{prog}.go && #{GO_LINKER} -o #{prog} #{prog}.#{GO_EXT}"
end

def go_run(prog, args = [], gomaxprocs = "")
  puts command = "sh -c \"#{gomaxprocs} ./#{prog} #{args.join(' ')}\""
  IO.popen(command) do |pipe|
    yield pipe.gets
  end
end

def write_results

  Dir.glob('*.go').each do |fn|
    lang = :go
    source = File.read(fn)
    template = ERB.new(File.read('source.rhtml'))
    File.open("#{File.basename(fn, '.go')}_go.html", 'w') { |f| f << template.result(binding)} 
  end

  Dir.glob('*.erl').each do |fn|
    lang = :erlang
    source = File.read(fn)
    template = ERB.new(File.read('source.rhtml'))
    File.open("#{File.basename(fn, '.erl')}_erlang.html", 'w') { |f| f << template.result(binding)} 
  end

  puts 'Wrote results in benchmark.html'
  template = ERB.new(File.read('benchmark.rhtml'))
  File.open('benchmark.html', 'w') { |f| f << template.result(binding) }
end

def system_info
  puts "$GOARCH: #{ENV['GOARCH']}"
  puts "compiler: #{GO_COMPILER}"
  puts "linker: #{GO_LINKER}"
end
