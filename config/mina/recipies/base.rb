require 'erb'

def template(from, to)
  queue %{echo "-----> Put #{from} file to #{to}"}
  erb = File.read(File.expand_path("../../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def put(content, file)
  queue %[echo #{escape content} > "#{file}"]
end

def escape(str)
  Shellwords.escape(str)
end
