require 'java'
require 'rubygems'
require 'mvn:rhino:js'

java_import org.mozilla.javascript.Context

context = Context.enter
scope = context.init_standard_objects

code = %[
  var javascriptInMyJavaInMyRuby = function() {
    return "Can you say polyglot programming?!";
  };
  
  javascriptInMyJavaInMyRuby();
]

puts context.evaluate_string scope, code, "example-1.js", 1, nil
