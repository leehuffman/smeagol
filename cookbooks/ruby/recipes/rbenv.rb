#
# Cookbook Name:: ruby
# Recipe:: rbenv
#
root = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "homebrew"))

require root + "/resources/homebrew"
require root + "/providers/homebrew"

SMEAGOL_ROOT_DIR = ENV['SMEAGOL_ROOT_DIR'] || "#{ENV['HOME']}/Developer"
DEFAULT_RUBY_VERSION = "1.8.7-p352"
DEFAULT_RUBY_19_VERSION = "1.9.3-p125"

script "installing rbenv to #{SMEAGOL_ROOT_DIR}" do
  interpreter "bash"
  code <<-EOS
    source #{SMEAGOL_ROOT_DIR}/cinderella.profile
    if [[ ! -d #{SMEAGOL_ROOT_DIR}/.rbenv ]]; then
      git clone git://github.com/sstephenson/rbenv.git #{SMEAGOL_ROOT_DIR}/.rbenv
    fi
  EOS
end

script "installing ruby-build to #{SMEAGOL_ROOT_DIR}" do
  interpreter "bash"
  code <<-EOS
    source #{SMEAGOL_ROOT_DIR}/cinderella.profile
    if [[ ! -x #{SMEAGOL_ROOT_DIR}/bin/ruby-build ]]; then
      git clone git://github.com/sstephenson/ruby-build.git #{Dir.tmpdir}/ruby-build >> ~/.cinderella/ruby.log
      cd #{Dir.tmpdir}/ruby-build && /usr/bin/env PREFIX=#{SMEAGOL_ROOT_DIR} ./install.sh >> ~/.cinderella/ruby.log
    fi
  EOS
end

script "installing ruby-#{DEFAULT_RUBY_VERSION} to #{SMEAGOL_ROOT_DIR}/.rbenv" do
  interpreter "bash"
  code <<-EOS
    source #{SMEAGOL_ROOT_DIR}/cinderella.profile

    if [ ! -d #{SMEAGOL_ROOT_DIR}/.rbenv/versions/#{DEFAULT_RUBY_VERSION} ]; then
      ruby-build #{DEFAULT_RUBY_VERSION} #{SMEAGOL_ROOT_DIR}/.rbenv/versions/#{DEFAULT_RUBY_VERSION}
    fi
  EOS
end

script "installing ruby-#{DEFAULT_RUBY_19_VERSION} to #{SMEAGOL_ROOT_DIR}/.rbenv" do
  interpreter "bash"
  code <<-EOS
    source #{SMEAGOL_ROOT_DIR}/cinderella.profile

    if [ ! -d #{SMEAGOL_ROOT_DIR}/.rbenv/versions/#{DEFAULT_RUBY_19_VERSION} ]; then
      ruby-build #{DEFAULT_RUBY_19_VERSION} #{SMEAGOL_ROOT_DIR}/.rbenv/versions/#{DEFAULT_RUBY_19_VERSION}
    fi
  EOS
end

script "ensuring a default ruby is set" do
  interpreter "bash"
  code <<-EOS
    source #{SMEAGOL_ROOT_DIR}/cinderella.profile
    `which ruby | grep -q rbenv`
    if [ $? -ne 0 ]; then
      rbenv init
      rbenv rehash
      rbenv global #{DEFAULT_RUBY_VERSION}
    fi
  EOS
end

[ DEFAULT_RUBY_VERSION, DEFAULT_RUBY_19_VERSION ].each do |ver|
  script "installing basic gems" do
    interpreter "bash"
    code <<-EOS
      source #{SMEAGOL_ROOT_DIR}/cinderella.profile
      rbenv local #{ver}
      gem install bundler heroku cinderella
      gem install rake -v=0.8.7
      rbenv rehash
    EOS
  end
end
