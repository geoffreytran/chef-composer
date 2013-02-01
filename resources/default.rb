actions :deploy, :install, :update

# Where to deploy composer.phar
attribute :deploy_to, :kind_of => String, :name_attribute => true
attribute :packages, :kind_of => String, :name_attribute => true
