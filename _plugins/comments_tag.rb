module Jekyll
  class Post

    alias :liquid_data :to_liquid

    def to_liquid
      liquid_data.deep_merge({
        "file_name" => file_name
      })
    end

  private

    def file_name
      # TODO: use File
      [@base, @name].join('/')
    end

  end
end

module Jekyll
  class CommentsTag < Liquid::Tag

    def initialize(tag_name, file, tokens)
      super
      @file = file
    end

    def render(context)
      file_name = context.environments.first["page"]["file_name"]

      cmd = "git log --pretty=format:'%h' --follow #{file_name}"
      hashes = `#{cmd}`.split('\n')

      puts hashes

      commit_id = '71a7950'
      #commit_id = `git rev-list -n 1 HEAD"# --`# #{__FILE__}"
      comments_url = "https://api.github.com/repos/polarblau/hastie-test-blog/commits/#{commit_id}/comments"
      "<div id='comments' data-comments-url='#{comments_url}'>#{@text}</div>"
    end
  end

private

  def caller_method_name
    parse_caller(caller(2).first).last
  end

  def parse_caller(at)
      if /^(.+?):(\d+)(?::in `(.*)')?/ =~ at
          file = Regexp.last_match[1]
      line = Regexp.last_match[2].to_i
      method = Regexp.last_match[3]
      [file, line, method]
    end
  end
end

Liquid::Template.register_tag('comments', Jekyll::CommentsTag)
