#require 'jekyll'
require 'fileutils'



module GitJekyllPreview


  def GitJekyllPreview.make_path(repo, ref, create =true)
    path = "checkouts/#{repo}/#{ref}"
    # create the dir if needed

    if !File.directory?(path) and create
      FileUtils.mkdir_p path
    end

    path
  end

  def fetchRepo(repo)
    # make sure the repo is up to date
    system "cd repos/#{repo}; git fetch"
  end

  def GitJekyllPreview.checkout(repo, ref)

    # checkout the specified ref
    path = make_path(repo, ref)
    puts path
    system "cd repos/#{repo}; git --work-tree=../../#{path} checkout #{ref} -- ."
  end

  def GitJekyllPreview.build(repo, ref)

    # build the site.
    path = make_path(repo, ref)

    system "cd #{path}; jekyll build"

  end




  def injectBaseTag(html)
    #heh

  end


  def GitJekyllPreview.isHTML(path)

    path_segments = path.split(".", -1)
    
    if path_segments.last.downcase == "html"
      return true
    end

    return false
  end


  def GitJekyllPreview.injectJavascript(html)

    js = File.read("rewrite_urls.js")
    new_html = ""

    html.split("\n", -1).each{ | line |

      if (line.downcase.index("</html>") != nil)
        new_html += "<script>"+js+"</script> \n"
      end
   
      new_html += line +"\n"
    }
    new_html
  end
end
