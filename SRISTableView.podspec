Pod::Spec.new do |s|
  s.name = 'SRISTableView'
  s.version = '0.0.7'
  s.license = 'MIT'
  s.summary = 'Easy infinite scrolling table views'
  s.homepage = 'https://github.com/StratRob/SRISTableView'
  s.authors = { 'Rob' => 'robbeyroad@gmail.com' }
  s.source = { :git => 'https://github.com/StratRob/SRISTableView.git', :tag => s.version }
  s.documentation_url = 'https://github.com/StratRob/SRISTableView'
  s.ios.deployment_target = '9.0'
  s.swift_versions = ['5.0']
  s.source_files = 'Source/**/*.swift'
end
