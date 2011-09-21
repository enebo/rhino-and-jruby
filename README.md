Integrating JRruby and Rhino
============================

These are 3 examples of how to use and control the Rhino javascript implementation from JRuby.

1. Executing javascript from JRuby
2. Controlling execution time and instruction count of a javascript
3. Exposing JRuby methods to javascript

To run these install the Rhino maven artifact as a gem from JRuby:
jruby -S gem install mvn:rhino:js

Then you any script as if it was any other Ruby script!
