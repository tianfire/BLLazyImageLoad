Pod::Spec.new do |s|
s.name = 'BLLazyImageLoad'
s.version = '0.1.1'
s.license = 'MIT'
s.summary = 'CableView/CollectionView images Lazy load.'
s.homepage = 'https://github.com/tianfire/BLLazyImageLoad'
s.authors = { 'tianfire' => 'libotian9999@gmail.com' }
s.source = { :git => "https://github.com/tianfire/BLLazyImageLoad.git", :tag => "0.1.1"}
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = "BLLazyImageLoad/LazyImageLoad/*.{h,m}"
s.dependency "SDWebImage"
end
