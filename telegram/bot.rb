require "telegram/bot"

TOKEN = Rails.application.credentials.telegram[:bot_token]

def web_app_url(user_id)
  "https://1017-193-57-42-47.ngrok-free.app/home?user_id=#{user_id}"
end

def find_or_create_user_from_telegram(message, bot)
  user_data = message.from

  # Extract full_name and telegram_id
  full_name = "#{user_data.first_name} #{user_data.last_name}".strip
  telegram_id = user_data.id

  # Find or initialize user by telegram_id
  user = User.find_or_create_by!(telegram_id: telegram_id) do |u|
    u.full_name = full_name
  end

  # Fetch avatar URL
  # response = bot.api.getUserProfilePhotos(user_id: telegram_id)
  # if response['result']['total_count'] > 0
  #   file_id = response['result']['photos'][0][0]['file_id']
  #   file = bot.api.getFile(file_id: file_id)
  #   avatar_url = "https://api.telegram.org/file/bot#{bot.token}/#{file['result']['file_path']}"

  #   # Download avatar and attach it
  #   avatar_file = URI.open(avatar_url)
  #   user.avatar.attach(io: avatar_file, filename: "avatar_#{telegram_id}.jpg")
  # end

  # user.save!
  user
end

Telegram::Bot::Client.run(TOKEN) do |bot|
  puts 'Bot is running...'

  bot.listen do |message|
    case message
    when Telegram::Bot::Types::Message
      chat_id = message.chat.id
      find_or_create_user_from_telegram message, bot

      bot.api.send_message(
        chat_id: chat_id,
        text: 'Click the button below to open the web app inside Telegram:',
        reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: [
            [
              Telegram::Bot::Types::InlineKeyboardButton.new(
                text: 'Open Web App',
                web_app: { url: web_app_url(chat_id) } # Web App configuration
              )
            ]
          ]
        )
      )
    end
  end
end
