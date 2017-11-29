describe Hisui::Management::Goal do
  let!(:user) { Hisui::User.new(access_token) }
  let!(:attributes) { {
    'id' => '1',
    'kind' => 'analytics#goal',
    'accountId' => '54516992',
    'webPropertyId' => 'UA-54516992-1',
    'profileId' => '90822334',
    'name' => 'Purchase Completed'
  } }
  let!(:goal) { Hisui::Management::Goal.new(attributes, user) }

  context 'Class methods' do
    context '#new' do
      it 'creates a new goal instance' do
        expect(goal.id).to eq('1')
        expect(goal.name).to eq('Purchase Completed')
        expect(goal.account_id).to eq('54516992')
        expect(goal.web_property_id).to eq('UA-54516992-1')
        expect(goal.profile_id).to eq('90822334')
      end
    end

    context '#for_account' do
      let!(:account) { user.accounts.first }
      let!(:goals_from_account) { Hisui::Management::Goal.for_account(account) }

      it 'returns goals from account' do
        expect(goals_from_account.length).to eq(12)

        expect(goals_from_account[0].id).to eq('1')
        expect(goals_from_account[0].name).to eq('Purchase Completed')
        expect(goals_from_account[1].id).to eq('2')
        expect(goals_from_account[1].name).to eq('Engaged Users')
        expect(goals_from_account[2].id).to eq('3')
        expect(goals_from_account[2].name).to eq('Registrations')
        expect(goals_from_account[3].id).to eq('4')
        expect(goals_from_account[3].name).to eq('Entered Checkout')

        expect(goals_from_account[4].id).to eq('1')
        expect(goals_from_account[4].name).to eq('Purchase Completed')
        expect(goals_from_account[5].id).to eq('2')
        expect(goals_from_account[5].name).to eq('Engaged Users')
        expect(goals_from_account[6].id).to eq('3')
        expect(goals_from_account[6].name).to eq('Registrations')
        expect(goals_from_account[7].id).to eq('4')
        expect(goals_from_account[7].name).to eq('Entered Checkout')

        expect(goals_from_account[8].id).to eq('1')
        expect(goals_from_account[8].name).to eq('Purchase Completed')
        expect(goals_from_account[9].id).to eq('2')
        expect(goals_from_account[9].name).to eq('Engaged Users')
        expect(goals_from_account[10].id).to eq('3')
        expect(goals_from_account[10].name).to eq('Registrations')
        expect(goals_from_account[11].id).to eq('4')
        expect(goals_from_account[11].name).to eq('Entered Checkout')
      end
    end

    context '#for_web_property' do
      let!(:web_property) { user.web_properties.first }
      let!(:goals_from_web_property) { Hisui::Management::Goal.for_web_property(web_property) }

      it 'returns goals from web property' do
        expect(goals_from_web_property.length).to eq(12)

        expect(goals_from_web_property[0].id).to eq('1')
        expect(goals_from_web_property[0].name).to eq('Purchase Completed')
        expect(goals_from_web_property[1].id).to eq('2')
        expect(goals_from_web_property[1].name).to eq('Engaged Users')
        expect(goals_from_web_property[2].id).to eq('3')
        expect(goals_from_web_property[2].name).to eq('Registrations')
        expect(goals_from_web_property[3].id).to eq('4')
        expect(goals_from_web_property[3].name).to eq('Entered Checkout')

        expect(goals_from_web_property[4].id).to eq('1')
        expect(goals_from_web_property[4].name).to eq('Purchase Completed')
        expect(goals_from_web_property[5].id).to eq('2')
        expect(goals_from_web_property[5].name).to eq('Engaged Users')
        expect(goals_from_web_property[6].id).to eq('3')
        expect(goals_from_web_property[6].name).to eq('Registrations')
        expect(goals_from_web_property[7].id).to eq('4')
        expect(goals_from_web_property[7].name).to eq('Entered Checkout')

        expect(goals_from_web_property[8].id).to eq('1')
        expect(goals_from_web_property[8].name).to eq('Purchase Completed')
        expect(goals_from_web_property[9].id).to eq('2')
        expect(goals_from_web_property[9].name).to eq('Engaged Users')
        expect(goals_from_web_property[10].id).to eq('3')
        expect(goals_from_web_property[10].name).to eq('Registrations')
        expect(goals_from_web_property[11].id).to eq('4')
        expect(goals_from_web_property[11].name).to eq('Entered Checkout')
      end
    end

    context '#for_profile' do
      let!(:profile) { user.profiles.first }
      let!(:goals_from_profile) { Hisui::Management::Goal.for_profile(profile) }

      it 'returns goals from profile' do
        expect(goals_from_profile.length).to eq(4)

        expect(goals_from_profile[0].id).to eq('1')
        expect(goals_from_profile[0].name).to eq('Purchase Completed')
        expect(goals_from_profile[1].id).to eq('2')
        expect(goals_from_profile[1].name).to eq('Engaged Users')
        expect(goals_from_profile[2].id).to eq('3')
        expect(goals_from_profile[2].name).to eq('Registrations')
        expect(goals_from_profile[3].id).to eq('4')
        expect(goals_from_profile[3].name).to eq('Entered Checkout')
      end
    end
  end

  context 'Instance methods' do
    context '.path' do
      it { expect(goal.path).to eq('/accounts/~all/webproperties/~all/profiles/~all/goals/1') }
    end
  end
end
