Pod::Spec.new do |s|
  s.name = 'PromisedFuture'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'A Swift based Future/Promises framework to help writing asynchronous code in an elegant way'
  s.homepage = 'https://github.com/AladinWay/PromisedFuture'
  s.authors = { 'Alaeddine Me' => 'itechnodev@gmail.com' }
  s.source = { :git => 'https://github.com/AladinWay/PromisedFuture.git', :tag => s.version }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'

  s.source_files = 'Source/*.swift'
end
