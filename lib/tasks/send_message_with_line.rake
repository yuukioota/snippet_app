require 'net/http'
require 'uri'

namespace :send_message_with_line do
  desc "ラインメッセージを送る"
  task send_message: :environment do
    class Line
      TOKEN = ENV['LINE_TOKEN']
      URI = URI.parse("https://notify-api.line.me/api/notify")
     
      def make_request(msg)
        request = Net::HTTP::Post.new(URI)
        request["Authorization"] = "Bearer #{TOKEN}"
        request.set_form_data(message: msg)
        request
      end
     
      def send(msg)
        request = make_request(msg)
        response = Net::HTTP.start(URI.hostname, URI.port, use_ssl: URI.scheme == "https") do |https|
          https.request(request)
        end
      end
    end
     
    all_snippets = Snippet.all
    
    all_snippets.each do |snippet|
      line     = Line.new
      language = "\n\n-言語    \n#{ snippet.language }"
      title    = "\n\n-タイトル\n#{ snippet.title    }"
      content  = "\n\n-内容    \n#{ snippet.contents }"
      msg      = language + title + content
      res      = line.send(msg)
    end
    
    line     = Line.new
    msg = %W(\n・20分の運動をしましょう ・紙に書きましょう ・声に出しましょう ・行動しましょう ・教えましょう)
    res      = line.send(msg.join("\n"))
    
  end
end
