def initialize(*args)
  super(*args)
end

def check_target(dir)

end

action :deploy do
  deploy_to = new_resource.name

  if !::File.directory?(deploy_to)
    raise "#{deploy_to} is not a directory"
  end

  if ::File.exists?("#{deploy_to}/composer.phar")
    Chef::Log.debug("The composer.phar is already in #{deploy_to} - skipping.")
  else
    env = { 'PATH' => '/usr/bin:/usr/local/bin:/bin' }
    
    unless new_resource.home.nil?
      env = Chef::Mixin::DeepMerge.merge(env, {
        'COMPOSER_HOME' => new_resource.home
      })
    end
    
    shell = Mixlib::ShellOut.new(
      "curl -s http://getcomposer.org/installer | php", 
      :env     => env, 
      :cwd     => deploy_to,
      :user    => node[:composer][:user],
      :group   => node[:composer][:group],
      :timeout => 3600
    )
    shell.run_command
  end
end

action :install do
  deploy_to = new_resource.name
  dev = new_resource.dev ? '--dev' : '--no-dev'

  if !::File.directory?(deploy_to)
    raise "#{deploy_to} is not a directory"
  end

  if !::File.exists?("#{deploy_to}/composer.phar")
    Chef::Log.info("Could not find \"composer.phar\"in #{deploy_to}")
  else
    env = { 'PATH' => '/usr/bin:/usr/local/bin:/bin' }
    
    unless new_resource.home.nil?
      env = Chef::Mixin::DeepMerge.merge(env, {
        'COMPOSER_HOME' => new_resource.home
      })
    end
    
    composer = Mixlib::ShellOut.new(
      "./composer.phar --no-interaction install --optimize-autoloader #{dev}",
      :env     => env,
      :cwd     => deploy_to,
      :user    => node[:composer][:user],
      :group   => node[:composer][:group],
      :timeout => 3600
    )
    composer.run_command
    composer.error!

  end
end

action :update do
  deploy_to = new_resource.name
  dev = new_resource.dev ? '--dev' : '--no-dev'

  if !::File.directory?(deploy_to)
    raise "#{deploy_to} is not a directory"
  end

  if !::File.exists?("#{deploy_to}/composer.phar")
    Chef::Log.info("Could not find \"composer.phar\"in #{deploy_to}")
  else
    env = { 'PATH' => '/usr/bin:/usr/local/bin:/bin' }
    
    unless new_resource.home.nil?
      env = Chef::Mixin::DeepMerge.merge(env, {
        'COMPOSER_HOME' => new_resource.home
      })
    end
    
    composer = Chef::ShellOut.new(
      "./composer.phar --no-interaction update --optimize-autoloader #{dev}",
      :env     => env,
      :cwd     => deploy_to,
      :user    => node[:composer][:user],
      :group   => node[:composer][:group],
      :timeout => 3600
    )
    composer.run_command
    composer.error!

  end
end
