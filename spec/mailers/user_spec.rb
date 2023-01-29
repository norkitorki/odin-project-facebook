require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  fixtures :users

  before do
    @user = users(:one)
    @email = UserMailer.with(user: @user).welcome_email
  end

  context "welcome_email" do
    it "should have the correct sender" do
      expect(@email.from.first).to eq('noreply@facebook.com')
    end

    it "should have to correct recipient" do
      expect(@email.to.first).to eq(@user.email)
    end

    it "should have the correct subject" do
      expect(@email.subject).to eq('Welcome to FakeFacebook!')
    end

    it "should have the correct html body" do
      expect(@email.html_part.body.to_s.gsub(' ', '')).to eq(read_fixture('welcome_email_html.yml').join.gsub(' ', ''))
    end

    it "should have the correct text body" do
      expect(@email.text_part.body.to_s).to eq(read_fixture('welcome_email_text.yml').join)
    end

    it "should send the email immediately" do
      @email.deliver_now
      expect(ActionMailer::Base.deliveries).to include(@email)
    end

    it "should enqueue the email" do
      expect { UserMailer.with(user: @user).welcome_email.deliver_later }.to have_enqueued_job.on_queue('default').exactly(:once)
    end
  end
end
