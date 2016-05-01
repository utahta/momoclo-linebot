module Linebot
  module Mcz
    module Notifier
      class ChannelItems
        def notify(mid = nil)
          Linebot::Mcz::Database.connect

          to_mid = mid.nil? ? user_mids : mid

          lined_at = DateTime.now
          channel_items.each do |item|
            item.lined_at = lined_at
            item.save!
            Linebot::Mcz.client.send_text(to_mid: to_mid, text: "#{item.channel.title}\n#{item.title}\n#{item.url}")
          end
        end

        private

        def channel_items
          Linebot::Mcz::Model::ChannelItem.joins(:channel).where(lined_at: nil)
        end

        def user_mids
          Linebot::Mcz::Model::User.all.pluck(:mid)
        end
      end
    end
  end
end
