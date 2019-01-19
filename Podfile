# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Githubclient' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Githubclient
  pod 'RealmSwift'
  pod 'SwiftKeychainWrapper', '~>3.0.1'
  
  pod 'p2.OAuth2', :git => 'https://github.com/p2/OAuth2', :submodules => true
  pod 'Siesta/UI', '~> 1.0'
  pod 'MarkdownView'
  
  target 'GithubclientTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GithubclientUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
