require 'rake/clean'
require 'erb'

GO_SYSTEM_INFO = { 'amd' => '6', '386' => '8', 'arm' => '5' }
GO_COMPILER = GO_SYSTEM_INFO[ENV['GOARCH']] + 'g'
GO_LINKER = GO_SYSTEM_INFO[ENV['GOARCH']] + 'l'
GO_EXT = GO_SYSTEM_INFO[ENV['GOARCH']]

CLOBBER.include '*.beam', "*.dump", "#*", "*.#{GO_EXT}", "*.html"

desc "Show system info"
task :info do
  puts "$GOARCH: #{ENV['GOARCH']}"
  puts "compiler: #{GO_COMPILER}"
  puts "linker: #{GO_LINKER}"
end

task :default => :spawn
