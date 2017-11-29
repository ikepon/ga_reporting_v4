describe Hisui::Management::Profile do
  let!(:user) { Hisui::User.new(access_token) }
  let!(:attributes) { {
    'kind' => 'analytics#profileSummary',
    'id' => '92320289',
    'name' => '1 Master View',
    'accountId' => '54516992',
    'type' => 'WEB',
    'webPropertyId' => 'UA-54516992-1'
  }.with_indifferent_access }
  let!(:profile) { Hisui::Management::Profile.new(attributes, user) }

  context 'Class methods' do
    context '#new' do
      it 'creates a new profile instance' do
        expect(profile.id).to eq('92320289')
        expect(profile.name).to eq('1 Master View')
        expect(profile.web_property_id).to eq('UA-54516992-1')
      end
    end

    context '#build_from_summary' do
      let!(:summary_attributes) { {
        'id' => '54516992',
        'kind' => 'analytics#accountSummary',
        'name' => 'Demo Account (Beta)',
        'webProperties' =>
        [{
          'kind' => 'analytics#webPropertySummary',
          'id' => 'UA-54516992-1',
          'name' => 'Google Merchandise Store',
          'internalWebPropertyId' => '87479473',
          'level' => 'STANDARD',
          'websiteUrl' => 'https://shop.googlemerchandisestore.com',
          'profiles'=> [{
            'kind' => 'analytics#profileSummary',
            'id' => '92320289',
            'name' => '1 Master View',
            'type' => 'WEB'
          },
          {
            'kind' => 'analytics#profileSummary',
            'id' => '92324711',
            'name' => '2 Test View',
            'type' => 'WEB'
          },
          {
            'kind' => 'analytics#profileSummary',
            'id' => '90822334',
            'name' => '3 Raw Data View',
            'type' => 'WEB'
          }]
        }]
      }.with_indifferent_access }
      let!(:profile_from_summary) { Hisui::Management::Profile.build_from_summary(summary_attributes, user) }

      it 'returns profile from account_summary' do
        expect(profile_from_summary.id).to eq('54516992')
        expect(profile_from_summary.name).to eq('Demo Account (Beta)')
        expect(profile_from_summary.user).to eq(user)
      end
    end

    context '#for_account' do
      let!(:account) { user.accounts.first }
      let!(:profiles_from_account) { Hisui::Management::Profile.for_account(account) }

      it 'returns profiles from account' do
        expect(profiles_from_account.length).to eq(3)

        expect(profiles_from_account.first.id).to eq('90822334')
        expect(profiles_from_account.first.name).to eq('3 Raw Data View')
        expect(profiles_from_account.first.account_id).to eq('54516992')
        expect(profiles_from_account.first.web_property_id).to eq('UA-54516992-1')

        expect(profiles_from_account.second.id).to eq('92320289')
        expect(profiles_from_account.second.name).to eq('1 Master View')
        expect(profiles_from_account.second.account_id).to eq('54516992')
        expect(profiles_from_account.second.web_property_id).to eq('UA-54516992-1')

        expect(profiles_from_account.third.id).to eq('92324711')
        expect(profiles_from_account.third.name).to eq('2 Test View')
        expect(profiles_from_account.third.account_id).to eq('54516992')
        expect(profiles_from_account.third.web_property_id).to eq('UA-54516992-1')
      end
    end

    context '#for_web_property' do
      let!(:web_property) { user.web_properties.first }
      let!(:profiles_from_web_property) { Hisui::Management::Profile.for_web_property(web_property) }

      it 'returns profiles from web property' do
        expect(profiles_from_web_property.length).to eq(3)

        expect(profiles_from_web_property.first.id).to eq('90822334')
        expect(profiles_from_web_property.first.name).to eq('3 Raw Data View')
        expect(profiles_from_web_property.first.account_id).to eq('54516992')
        expect(profiles_from_web_property.first.web_property_id).to eq('UA-54516992-1')

        expect(profiles_from_web_property.second.id).to eq('92320289')
        expect(profiles_from_web_property.second.name).to eq('1 Master View')
        expect(profiles_from_web_property.second.account_id).to eq('54516992')
        expect(profiles_from_web_property.second.web_property_id).to eq('UA-54516992-1')

        expect(profiles_from_web_property.third.id).to eq('92324711')
        expect(profiles_from_web_property.third.name).to eq('2 Test View')
        expect(profiles_from_web_property.third.account_id).to eq('54516992')
        expect(profiles_from_web_property.third.web_property_id).to eq('UA-54516992-1')
      end
    end
  end

  context 'Instance methods' do
    context '.path' do
      it { expect(profile.path).to eq('/accounts/54516992/webproperties/UA-54516992-1/profiles/92320289') }
    end

    context '.goals' do
      let!(:goals) { profile.goals }
      it 'returns goals about profile' do
        expect(goals.length).to eq(4)

        expect(goals[0].id).to eq('1')
        expect(goals[0].name).to eq('Purchase Completed')
        expect(goals[0].account_id).to eq('54516992')
        expect(goals[0].web_property_id).to eq('UA-54516992-1')
        expect(goals[0].profile_id).to eq('92320289')

        expect(goals[1].id).to eq('2')
        expect(goals[1].name).to eq('Engaged Users')
        expect(goals[1].account_id).to eq('54516992')
        expect(goals[1].web_property_id).to eq('UA-54516992-1')
        expect(goals[1].profile_id).to eq('92320289')

        expect(goals[2].id).to eq('3')
        expect(goals[2].name).to eq('Registrations')
        expect(goals[2].account_id).to eq('54516992')
        expect(goals[2].web_property_id).to eq('UA-54516992-1')
        expect(goals[2].profile_id).to eq('92320289')

        expect(goals[3].id).to eq('4')
        expect(goals[3].name).to eq('Entered Checkout')
        expect(goals[3].account_id).to eq('54516992')
        expect(goals[3].web_property_id).to eq('UA-54516992-1')
        expect(goals[3].profile_id).to eq('92320289')
      end
    end
  end
end
