require 'rake/clean'
require 'erb'

GO_SYSTEM_INFO = { 'amd' => '6', '386' => '8', 'arm' => '5' }
GO_COMPILER = GO_SYSTEM_INFO[ENV['GOARCH']] + 'g'
GO_LINKER = GO_SYSTEM_INFO[ENV['GOARCH']] + 'l'
GO_EXT = GO_SYSTEM_INFO[ENV['GOARCH']]

CLOBBER.include '*.beam', "*.dump", "#*", "*.#{GO_EXT}", "*.html"

def get_uptime
  'Uptime: ' + `uptime`[/up (.+?),/,1]
end

def get_hostname
  'System Info for: ' + `hostname`.chomp.strip
end

def get_kernel
  'OS/Kernel: ' + `uname -sr`.chomp.strip
end

def get_ram
  result = `cat /proc/meminfo`
  line = 'Memory: '

  total, free = 0
  result.split("\n").each do |l|
    key, value = l.split(':',2).map{|x| x.strip}
    if key == 'MemTotal'
      mem, foo = value.split
      total = mem.to_i/1024
    elsif key == 'MemFree'
      mem, foo = value.split
      free = mem.to_i/1024
    end
  end
  percent = ((free/total.to_f)*100).ceil
  line += "#{free}/#{total}MB(#{percent}%)"
end

def get_cpu        
  result = `cat /proc/cpuinfo`
  cpus = result.split("\n\n")
  res = []
  cpus.each do |c|
    line = 'CPU INFO: '
    c.split("\n").each do |l|

      key, value = l.split(':', 2).map{|x| x.strip}

      if key == 'model name'
        line << value+' '
      elsif key == 'cpu MHz'
        line << value+'MHz '
      elsif key == 'bogomips'
        line << value+' Bogomips '
      end
    end
    res << line
  end
  res
end

def erlang_compile(fn)
  sh "erlc #{fn}.erl"
end

def erlang_run(prog, args = [])
  puts command = "erl -noshell -pa #{Dir.pwd} -s #{prog} start #{args.shift} -s init stop #{args.join(' ')}"
  (@erl_cmd ||= []) << command
  IO.popen(command) do |pipe|
    yield pipe.gets
  end
end

def go_compile(prog)
  sh "#{GO_COMPILER} #{prog}.go && #{GO_LINKER} -o #{prog} #{prog}.#{GO_EXT}"
end

def go_run(prog, args = [], gomaxprocs = "")
  puts command = "sh -c \"#{gomaxprocs} ./#{prog} #{args.join(' ')}\""
  (@go_cmd ||= []) << command
  IO.popen(command) do |pipe|
    yield pipe.gets
  end
end

def go_version
  `#{GO_COMPILER} -V`
end

def erlang_version
  IO.popen("sh -c \"erl -version 2>&1\"") { |pipe| pipe.gets }
end

def write_results

  Dir.glob('*.go').each do |fn|
    lang = :go
    source = File.read(fn)
    template = ERB.new(File.read('source.rhtml'))
    File.open("#{File.basename(fn, '.go')}_go.html", 'w') { |f| f << template.result(binding) } 
  end

  Dir.glob('*.erl').each do |fn|
    lang = :erlang
    source = File.read(fn)
    template = ERB.new(File.read('source.rhtml'))
    File.open("#{File.basename(fn, '.erl')}_erlang.html", 'w') { |f| f << template.result(binding) } 
  end

  template = ERB.new(File.read('system_info.rhtml'))
  File.open('system_info.html', 'w') { |f| f << template.result(binding) }

  puts 'Wrote results in benchmark.html'
  template = ERB.new(File.read('benchmark.rhtml'))
  File.open('benchmark.html', 'w') { |f| f << template.result(binding) }
end

def system_info
  puts "$GOARCH: #{ENV['GOARCH']}"
  puts "compiler: #{GO_COMPILER}"
  puts "linker: #{GO_LINKER}"
end


