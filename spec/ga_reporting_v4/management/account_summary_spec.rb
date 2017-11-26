describe GaReportingV4::Management::AccountSummary do
  let!(:user) { GaReportingV4::User.new(access_token) }
  let!(:attributes) { {
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
  let!(:account_summary) { GaReportingV4::Management::AccountSummary.new(attributes, user) }

  context 'Class methods' do
    context '#new' do
      it 'creates a new account summary instance' do
        expect(account_summary.account.class).to eq(GaReportingV4::Management::Account)
        expect(account_summary.user).to eq(user)
      end
    end
  end

  context 'Instance methods' do
    context '#profiles' do
      it 'returns profiles' do
        expect(account_summary.profiles.length).to eq(3)

        expect(account_summary.profiles.first.id).to eq('92320289')
        expect(account_summary.profiles.first.name).to eq('1 Master View')
        expect(account_summary.profiles.first.web_property_id).to eq('UA-54516992-1')

        expect(account_summary.profiles.second.id).to eq('92324711')
        expect(account_summary.profiles.second.name).to eq('2 Test View')
        expect(account_summary.profiles.second.web_property_id).to eq('UA-54516992-1')

        expect(account_summary.profiles.third.id).to eq('90822334')
        expect(account_summary.profiles.third.name).to eq('3 Raw Data View')
        expect(account_summary.profiles.third.web_property_id).to eq('UA-54516992-1')
      end
    end

    context '#web_properties' do
      it 'returns web properties' do
        expect(account_summary.web_properties.length).to eq(1)

        web_property = account_summary.web_properties.first
        expect(web_property.id).to eq('UA-54516992-1')
        expect(web_property.name).to eq('Google Merchandise Store')
        expect(web_property.account_id).to eq('54516992')
        expect(web_property.website_url).to eq('https://shop.googlemerchandisestore.com')
      end
    end
  end
end
