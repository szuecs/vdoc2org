
namespace :build do
  desc "Build and package release with MacRuby Framework"
  task :release do
    #sh %{xcodebuild && macruby_deploy --embed --gem nokogiri build/Release/vdoc2org.app}
    system %q{mkdir build/Release/vdoc2org.app} unless File.exists? "build/Release/vdoc2org.app"
    system %q{xcodebuild && macruby_deploy --embed --gem nokogiri build/Release/vdoc2org.app}
  end
end
