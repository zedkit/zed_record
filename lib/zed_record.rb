##
# Copyright (c) Zedkit.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##

require 'rubygems'
require 'zedkit'
require 'zeddb'

module ZedDB
  class ZedRecord
    attr_accessor :new_record

    INSTANCE_ATTRIBUTES = ['uuid', 'created_at', 'updated_at']

    def initialize
      set_attributes
    end
    def initialize(values = {})
      set_attributes
      values.each {|k,v| self.instance_variable_set("@#{k}", v) }
    end

    def new_record?
      @new_record
    end

    private
    def set_attributes
      (self.class.class_variable_get(:@@attributes) + ZedDB::ZedRecord::INSTANCE_ATTRIBUTES).each do |name|
        self.instance_variable_set("@#{name}", nil)
        self.class.send(:define_method, name, Proc.new { self.instance_variable_get("@#{name}") })
        self.class.send(:define_method, "#{name}=", Proc.new {|v| self.instance_variable_set("@#{name}", v) })
      end
      uuid.nil? ? @new_record = true : @new_record = false
    end
  end
end

require 'zed_record/initializer.rb'
