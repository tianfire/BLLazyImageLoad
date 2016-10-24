Pod::Spec.new do |s|
s.name = 'BLLazyImageLoad'
s.version = '0.1.2'
s.license = 'MIT'
s.summary = 'TableView / CollectionView images Lazy load.'
s.homepage = 'https://github.com/tianfire/BLLazyImageLoad'
s.authors = { 'tianfire' => 'libotian9999@gmail.com' }
s.source = { :git => "https://github.com/tianfire/BLLazyImageLoad.git", :tag => s.version }
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = "BLLazyImageLoad/LazyImageLoad/*.{h,m}"
s.dependency "SDWebImage"
end
