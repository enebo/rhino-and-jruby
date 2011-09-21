# Limiting resource use
require 'java'
require 'rubygems'
require 'mvn:rhino:js'

java_import org.mozilla.javascript.Context
java_import org.mozilla.javascript.ContextFactory

class RestrictedContext < Context
  attr_accessor :start_time, :instruction_count
end
  
class RestrictedContextFactory < ContextFactory
  INSTRUCTION_LIMIT, TIME_LIMIT = 1000, 1
  
  def self.restrict(context)
    context.instruction_observer_threshold = 100
    # JS Interp-mode supports this feature
    context.optimization_level = -1 
  end
  
  def restrict(context)
    self.class.restrict context
  end
  
  def makeContext
    RestrictedContext.new.tap { |context| restrict context }
  end

  def observeInstructionCount(context, instruction_count)
    context.instruction_count += instruction_count

    if context.instruction_count > INSTRUCTION_LIMIT || 
        (Time.now - context.start_time).to_i > TIME_LIMIT
      raise "Yikes! Wayyyy too many instructions for me!"
    end
  end

  def doTopCall(callable, context, scope, this_obj, args)
    context.start_time = Time.now
    context.instruction_count = 0
    super
  end 
end

ContextFactory.init_global RestrictedContextFactory.new
context = Context.enter
scope = context.init_standard_objects

code = %[
  out = Packages.java.lang.System.out

  for (i = 0; i < 10000000000; i++) {
    out.println(i);
  }
]

puts context.evaluate_string scope, code, "example-2.js", 1, nil
