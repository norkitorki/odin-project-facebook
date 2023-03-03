require 'rails_helper'

RSpec.describe "Users", type: :system do
  include Devise::Test::IntegrationHelpers

  fixtures :users

  before do
    driven_by(:rack_test)
    sign_in @user = users(:one)
  end

  context "when signing up" do
    before do
      sign_out @user
      visit new_user_registration_path
    end

    it "should visit sign up page" do
      expect(page).to have_current_path(new_user_registration_path)
    end

    it "should sign user up" do
      fill_in 'Email', with: 'test@testing.com'
      fill_in 'First name', with: 'A'
      fill_in 'Last name', with: 'Tester'
      fill_in 'Birthday', with: Date.new(2000)
      fill_in 'Password', with: '1234567'
      fill_in 'Password confirmation', with: '1234567'
      
      expect { click_on 'Sign up' }.to change { User.count }.by(1)
      assert_text 'You have signed up successfully.'
    end
  end

  context "when signing in" do
    before do
      sign_out @user
      visit new_user_session_path
    end

    it "should visit sign in page" do
      expect(page).to have_current_path(new_user_session_path)
    end

    it "should sign user in" do
      password = '******'
      @user.update(password: password)
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: password
      click_on 'Log in'

      assert_text 'Signed in successfully.'
    end

    context "when user has forgotten the password" do
      before do
        click_on 'Forgot your password?'
      end

      it "should visit forgot password page" do
        expect(page).to have_current_path(new_user_password_path)
      end

      it "should request new password instructions" do
        fill_in 'Email', with: @user.email
        click_on 'Send me reset password instructions'

        assert_text 'You will receive an email with instructions on how to reset your password in a few minutes.'
      end
    end
  end

  context "when signed in" do
    it "should be able to sign out" do
      visit root_path

      within('#sign-out-form') do
        click_on 'Sign Out'
      end
      
      expect(page).to have_current_path(sign_in_path)
    end

    describe "show" do
      before do
        visit user_path(@user)
      end

      it "should visit user profile page" do
        expect(page).to have_current_path(user_path(@user))
      end

      it "should be viewing comments" do
        click_on 'Comments'
        expect(page).to have_current_path(comments_user_path(@user))
      end

      it "should be viewing friends" do
        click_on 'Friends'
        expect(page).to have_current_path(friends_user_path(@user))
      end
    end

    describe "edit" do
      before do
        visit edit_user_registration_path(@user)
      end

      it "should visit user edit page" do
        expect(page).to have_current_path(edit_user_registration_path(@user))
      end

      it "should cancel user account" do
        expect { click_on 'Cancel my account' }.to change { User.count }.by(-1)
      end

      context "when editing user" do
        let(:password) { '***password***' }

        before do
          @user.update(password: password)
          sign_in @user
          fill_in 'Current Password', with: password
        end

        it "should update email" do
          email = 'testing@tester.net'
          fill_in 'Email', with: email

          expect { click_on 'Update' }.to change { @user.reload.email }.to(email)
          assert_text 'Your account has been updated successfully.'
        end

        it "should update password" do
          new_password = 'ThisIsMyNewPassword123'
          fill_in 'New Password', with: new_password
          fill_in 'New Password Confirmation', with: new_password
          click_on 'Update'

          assert_text 'Your account has been updated successfully.'
        end
      end
    end
  end
end
