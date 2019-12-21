# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

RX_SWIFT_VERSION = '5.0.1'.freeze
SNAPKIT_VERSION = '5.0.1'.freeze

def arch_pods
  pod 'RxSwift', git: 'https://github.com/ReactiveX/RxSwift.git', tag: RX_SWIFT_VERSION
  pod 'RxRelay', git: 'https://github.com/ReactiveX/RxSwift.git', tag: RX_SWIFT_VERSION
  pod 'RxCocoa', git: 'https://github.com/ReactiveX/RxSwift.git', tag: RX_SWIFT_VERSION
end

def ui_pods
  pod 'SnapKit', SNAPKIT_VERSION
end

target 'Architecture' do
  use_frameworks!

  arch_pods

  target 'ArchitectureTests' do
  end
end

target 'Counter' do
  use_frameworks!

  arch_pods
  ui_pods

  target 'CounterTests' do
  end
end

target 'PrimeModal' do
  use_frameworks!

  arch_pods
  ui_pods

  target 'PrimeModalTests' do
  end
end

target 'FavoritePrimes' do
  use_frameworks!

  arch_pods
  ui_pods

  target 'FavoritePrimesTests' do
  end
end

target 'PrimeTime' do
  use_frameworks!

end
