describe GaReportingV4::Management::Account do
  let!(:user) { GaReportingV4::User.new(access_token) }
  let!(:account) { GaReportingV4::Management::Account.new({'id' => 54516992, 'name' => 'Demo Account (Beta)'}, user) }
  let!(:web_property) { account.web_properties.first }

  context 'Class methods' do
    context '#new' do
      it 'creates a new account instance' do
        expect(account.id).to eq(54516992)
        expect(account.name).to eq('Demo Account (Beta)')
        expect(account.user).to eq(user)
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
      let!(:account_from_summary) { GaReportingV4::Management::Account.build_from_summary(summary_attributes, user) }

      it 'returns account from account_summary' do
        expect(account_from_summary.id).to eq('54516992')
        expect(account_from_summary.name).to eq('Demo Account (Beta)')
        expect(account_from_summary.user).to eq(user)
      end
    end

    context '#from_child' do
      let!(:account_from_child) { GaReportingV4::Management::Account.from_child(web_property) }
      it 'returns account from web_property' do
        expect(account_from_child.id).to eq('54516992')
        expect(account_from_child.name).to eq('Demo Account (Beta)')
        expect(account_from_child.user).to eq(user)
      end
    end
  end

  context 'Instance methods' do
    context '.path' do
      it 'returns a acounts path' do
        expect(account.path).to eq('/accounts/54516992')
      end
    end

    context '.web_properties' do
      it 'returns web properties' do
        expect(account.web_properties.length).to eq(1)

        web_property = account.web_properties.first
        expect(web_property.id).to eq('UA-54516992-1')
        expect(web_property.name).to eq('Google Merchandise Store')
        expect(web_property.account_id).to eq('54516992')
        expect(web_property.website_url).to eq('https://shop.googlemerchandisestore.com')
      end
    end

    context '.profiles' do
      it 'returns profiles' do
        expect(account.profiles.length).to eq(3)

        expect(account.profiles.first.id).to eq('90822334')
        expect(account.profiles.first.name).to eq('3 Raw Data View')
        expect(account.profiles.first.account_id).to eq('54516992')
        expect(account.profiles.first.web_property_id).to eq('UA-54516992-1')

        expect(account.profiles.second.id).to eq('92320289')
        expect(account.profiles.second.name).to eq('1 Master View')
        expect(account.profiles.second.account_id).to eq('54516992')
        expect(account.profiles.second.web_property_id).to eq('UA-54516992-1')

        expect(account.profiles.third.id).to eq('92324711')
        expect(account.profiles.third.name).to eq('2 Test View')
        expect(account.profiles.third.account_id).to eq('54516992')
        expect(account.profiles.third.web_property_id).to eq('UA-54516992-1')
      end
    end
  end
end
