Pod::Spec.new do |s|
  s.name = 'PromisedFuture'
  s.version = '1.0.1'
  s.summary = 'A Swift based Future/Promises framework to help writing asynchronous code in an elegant way'

  s.description      = <<-DESC
  Future/Promises framework to help to build easily composable and chainable asynchronous tasks.
  DESC

  s.homepage = 'https://github.com/AladinWay/PromisedFuture'
  s.screenshots = 'http://www.itechnodev.com/img/logo.png'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.authors = { 'Alaeddine Messaoudi' => 'itechnodev@gmail.com' }
  s.source = { :git => 'https://github.com/AladinWay/PromisedFuture.git', :tag => s.version }


  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '3.0'

  s.source_files = 'Source/**/*.{h,m,swift}'
end
