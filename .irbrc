require 'rubygems'
require 'irb/completion'

if defined?(Rails)
  require 'logger'
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT_MODE] = false
IRB.conf[:USE_AUTOCOMPLETE] = false
