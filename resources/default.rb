actions :deploy, :install, :update

# Where to deploy composer.phar
attribute :deploy_to, :kind_of => String, :name_attribute => true
attribute :home, :kind_of => String, :default => nil
attribute :dev, :kind_of => [TrueClass, FalseClass], :default => true
