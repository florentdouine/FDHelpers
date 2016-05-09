Pod::Spec.new do |s|
  s.name             = "FDHelpers"
  s.version          = "0.9"
  s.summary          = "Tools and helpers function for FD"
  s.homepage         = "https://github.com/florentdouine/FDHelpers"
  s.license      = { :type => 'Apache License, Version 2.0', :text => <<-LICENSE
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    LICENSE
  }
  s.author           = { "FlorentDouine" => "florent@douine.fr" }
  s.source           = { :git => "https://github.com/florentdouine/FDHelpers.git", :tag => s.version }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Classes/*.swift'

  s.frameworks = 'UIKit'
  s.module_name = 'FDHelpers'
end
