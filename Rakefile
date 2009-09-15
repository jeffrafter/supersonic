require 'rubygems'
require 'rake'

task :default => :compile

desc "Compile the supersonic kit"
task :compile do
  `cd src; mtasc -v -swf ../supersonic.swf -main -header 200:200:0 supersonic.as`
end