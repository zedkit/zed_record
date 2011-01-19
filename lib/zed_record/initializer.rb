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

module Zedkit
  class ZedRecords
    class << self
      @@initialized = false

      def init!
        if Zedkit.configuration.has_project_key? && constants_still_to_be_done?
          pp = Zedkit::Projects.verify(:project, Zedkit.configuration.project_key)
          sn = Zedkit::Projects.snapshot(:user_key => nil, :uuid => pp['uuid'])
          sn['models'].each do |pm|

            klass = Class.new ZedDB::ZedRecord
            klass.class_variable_set(:@@attributes, pm['items'].map {|mi| mi['name'] })
            ZedDB.const_set pm['model_name'], klass
            
            @@initialized = true
          end
        end
      end
      
      def constants_initialized?
        @@initialized
      end
      def constants_still_to_be_done?
        not constants_initialized?
      end
    end
  end
end
