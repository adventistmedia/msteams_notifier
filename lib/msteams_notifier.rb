require "msteams_notifier/version"
require "net/http"
require "json"

module MsteamsNotifier
  class Error < StandardError; end

  class Message

    attr_accessor :enabled, :webhook_url, :quick_title

    # A quick method to send a text notification
    def self.quick_message(message)
      notifier = MsteamsNotifier::Message.new
      if !notifier.quick_title.nil? && !notifier.quick_title != ""
        notifier.add_title notifier.quick_title
      end
      notifier.add_text(message)
      
      notifier.send
    end

  	def initialize(options={})
      @enabled = options[:enabled] || (defined?(Rails) ? Rails.application.credentials.dig(:ms_teams, :enabled).to_s == "1" : true)
      @webhook_url = options[:webhook_url] || (defined?(Rails) ? Rails.application.credentials.dig(:ms_teams, :webhook_url) : "")
      @quick_title = options[:quick_title] || (defined?(Rails) ? Rails.application.credentials.dig(:ms_teams, :quick_title) : nil)
      @items = []
      @actions = []
  	end

    def add_title(title)
      @items << {
          "type": "TextBlock",
          "text": title,
          "weight": "bolder",
          "size": "medium"
        }
    end

    def add_text(text)
      @items << {
          "type": "TextBlock",
          "text": text,
          "wrap": true
        }
    end

    def add_action(title, url)
      @actions << {
          "type": "Action.OpenUrl",
          "title": title,
          "url": url
        }
    end

    # facts: [{title: 'Label', value: 'Thing'}]
    def add_facts(facts)
      @items << {
        "type": "FactSet",
        facts: facts
      }
    end

    # Should we really send the message. Helpful when in development
    def sending_enabled?
      @enabled
    end

    def send
      return false unless sending_enabled?
      begin
        uri = URI(@webhook_url.to_s)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(uri.request_uri)
        request["Content-Type"] = "application/json"
        request.body = json_payload
        response = http.request(request)
        response.is_a?(Net::HTTPSuccess)
      rescue => e
        puts e.message
        puts e.backtrace
        false
      end
  	end

    def json_payload
      {
       "type": "message",
       "attachments":[
          {
             "contentType": "application/vnd.microsoft.card.adaptive",
             "contentUrl": nil,
             "content": {
                "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                "type": "AdaptiveCard",
                "version": "1.2",
                "body": [
                  {
                    "type": "Container",
                    "items": @items
                  }
                ],
                "actions": @actions
             }
          }
       ]
     }.to_json
  	end

  end

end
