# Exposing Ruby methods
require 'net/http'
require 'java'
require 'rubygems'
require 'mvn:rhino:js'

java_import org.mozilla.javascript.Context
java_import org.mozilla.javascript.NativeFunction
java_import org.mozilla.javascript.ScriptableObject

class HttpFunction < NativeFunction
  def call(context, scope, scriptable, args)
    Net::HTTP.get URI.parse(args[0])
  end
end

context = Context.enter
scope = context.init_standard_objects

ScriptableObject.put_property scope, "http", HttpFunction.new

code = %[  http("http://www.webpop.com") ]

puts context.evaluate_string scope, code, "example-3.js", 1, nil
