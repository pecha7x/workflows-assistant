require 'application_system_test_case'

class GmailMessagesTest < ApplicationSystemTestCase
  setup do
    login_as users(:user1)

    @gmail_message = gmail_messages(:first)
  end

  test 'Displays a list of gmail messages' do
    visit gmail_messages_path

    assert_selector 'h2', text: 'Gmail Messages'
    assert_selector 'table', class: 'gmail-messages'
    assert_selector 'td', class: 'gmail-message-item__from', text: @gmail_message.from
  end

  test 'Shows a gmail messages' do
    visit gmail_message_path(@gmail_message)

    assert_text @gmail_message.from
    assert_text @gmail_message.subject
    assert_text @gmail_message.body
  end
end
