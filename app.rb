require 'sinatra'
require './gitjekyllpreview'
require 'uri'

 
get '/' do

  "something"
end

get '/:repo/:ref/?*' do

  req_path = request.path
  
  file_path = req_path.sub("/#{params[:repo]}/#{params[:ref]}/", "")
  path = GitJekyllPreview.make_path(params[:repo], params[:ref], false)



  #http://localhost:9292/beyondtransparency/HEAD/index.html

  if !File.directory?(path)

    puts "Not found... checkout and build"
    GitJekyllPreview.checkout(params[:repo], params[:ref])
    GitJekyllPreview.build(params[:repo], params[:ref])
  end

  puts "#{params[:repo]} #{params[:ref]} #{request.path} #{file_path}"
  

  if File.directory?("#{path}/_site/#{file_path}")

    #if the path is a directory, we should return the index

    if file_path[file_path.length] != "/"
      file_path += "/"
    end

    file_path += "index.html"

  end

  puts "FILE PATH"
  puts file_path


  if GitJekyllPreview.isHTML(file_path)

    html = File.read("#{path}/_site/#{file_path}")
    html = GitJekyllPreview.injectJavascript(html)

    puts "INJECTING JS"

    body html
  else
    send_file "#{path}/_site/#{file_path}"
  end

end
 

