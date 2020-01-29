desired_settings = {
  master: [
    :localcacert,
    :ssldir
  ],
  main: [
    :hostpubkey,
    :hostprivkey,
    :hostcert,
    :localcacert,
    :ssldir,
    :vardir,
    :server
  ]
}
Facter.add(:puppet_config) do
  puppet_config = {}
  setcode do
    desired_settings.each_pair do |section, settings|
      settings.each do |setting|
        puppet_config[section.to_s] = {} unless puppet_config.key?(section.to_s)
        puppet_config[section.to_s][setting.to_s] = Puppet.settings.values(
          Puppet[:environment].to_sym, section
        ).interpolate(setting)
      end
    end
    puppet_config
  end
end
