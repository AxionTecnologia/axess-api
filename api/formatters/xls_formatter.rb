module XlsFormatter
  def self.call(object, env)
    path = env['api.endpoint'].options[:route_options][:xls]
    erubis = Erubis::Eruby.new(File.read("#{Project.root}/views/#{path}.erubis"))
    erubis.result({
      object: object
    })
  end
end
