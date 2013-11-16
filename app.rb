require 'sinatra'
require './gitjekyllpreview'
require 'uri'

 
def checkReferer

  req_path = request.path

  if(request.referrer)
    uri = URI(request.referrer)

    if uri.host == request.host
      path_segments = uri.path.split("/", -1)

      if(path_segments.length > 3)

        repo = path_segments[1]
        ref = path_segments[2]

        if(req_path.index("/"+repo+"/"+ref) == nil)
          redirect "/"+repo+"/"+ref+req_path, 302
        end
      end
    end
  end
end


def serveFile(path, file_path)

  if File.directory?("#{path}/_site/#{file_path}")

    #if the path is a directory, we should return the index

    if file_path[file_path.length] != "/"
      file_path += "/"
    end

    file_path += "index.html"

  end

  send_file "#{path}/_site/#{file_path}"

end

def getRepoFromPath(path)

  path_segments = path.split("/", -1)

  {:repo => path_segments[1],
    :ref => path_segments[2]}
end

get '/preview/*' do

  path = request.path.sub("/preview", "")

  repo = getRepoFromPath(path)

  info = GitJekyllPreview.repoInfo(repo[:repo], repo[:ref])

  
  erb :preview, :locals => {
    :repo => repo[:repo], 
    :prevref => info[:prev], 
    :nextref => "", 
    :branches => [""], 
    :url => path }
end

get '/:repo/:ref/?*' do

  req_path = request.path

  file_path = req_path.sub("/#{params[:repo]}/#{params[:ref]}/", "")
  path = GitJekyllPreview.make_path(params[:repo], params[:ref], false)

  checkReferer

  if !File.directory?(path)

    puts "Not found... checkout and build"
    GitJekyllPreview.checkout(params[:repo], params[:ref])
    GitJekyllPreview.build(params[:repo], params[:ref])
  end

  serveFile(path, file_path)

end
 
get '*' do
  checkReferer
  serveFile(path, file_path)
end
