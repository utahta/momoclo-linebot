module Linebot
  module Mcz
    class MessageApi
      def initialize
        @logger = Linebot::Mcz::Logger.new
        @conn = Faraday::Connection.new(url: 'https://trialbot-api.line.me/v1/events') do |faraday|
          faraday.request  :url_encoded
          faraday.response :logger, @logger
          faraday.adapter  Faraday.default_adapter
        end
      end

      def post_text(to, text)
        @logger.info("to:#{to} text:#{text}")
        request_content = create_request_content(to, { contentType: 1, toType: 1, text: text })
        @conn.post do |req|
          req.headers.update(headers_hash)
          req.body = request_content.to_json
        end
      end

      def post_image(to, original_content_url, preview_image_url)
        @logger.info("to:#{to}")
        request_content = create_request_content(to, {
            contentType: 2,
            toType: 1,
            originalContentUrl: original_content_url,
            previewImageUrl: preview_image_url
        })
        @conn.post do |req|
          req.headers.update(headers_hash)
          req.body = request_content.to_json
        end
      end

      private

      def create_request_content(to, content)
        {
            to: to,
            toChannel: 1383378250,
            eventType: '138311608800106203',
            content: content
        }
      end

      def headers_hash
        {
            'Content-Type': 'application/json; charser=UTF-8',
            'X-Line-ChannelID': ENV.fetch('LINE_CHANNEL_ID'),
            'X-Line-ChannelSecret': ENV.fetch('LINE_CHANNEL_SECRET'),
            'X-Line-Trusted-User-With-ACL': ENV.fetch('LINE_TRUSTED_USER_WITH_ACL')
        }
      end
    end
  end
end
