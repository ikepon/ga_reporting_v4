describe Hisui::Management::WebProperty do
  let!(:user) { Hisui::User.new(access_token) }
  let!(:attributes) { {
    'id' => 'UA-54516992-3',
    'name' => 'Demo Account (Beta)',
    'accountId' => '54516992',
    'websiteUrl' => 'https://shop.googlemerchandisestore.com'
  }.with_indifferent_access }
  let!(:web_property) { Hisui::Management::WebProperty.new(attributes, user) }

  context 'Class methods' do
    context '#new' do
      it 'creates a new web property instance' do
        expect(web_property.id).to eq('UA-54516992-3')
        expect(web_property.name).to eq('Demo Account (Beta)')
        expect(web_property.account_id).to eq('54516992')
        expect(web_property.website_url).to eq('https://shop.googlemerchandisestore.com')
        expect(web_property.user).to eq(user)
      end
    end

    context '#build_from_summary' do
      let!(:account_summary) { {
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
      }.with_indifferent_access }
      let!(:web_property_from_summary) { Hisui::Management::WebProperty.build_from_summary(account_summary, user) }

      it 'creates a new web property instance' do
        expect(web_property.id).to eq('UA-54516992-3')
        expect(web_property.name).to eq('Demo Account (Beta)')
        expect(web_property.account_id).to eq('54516992')
        expect(web_property.website_url).to eq('https://shop.googlemerchandisestore.com')
        expect(web_property.user).to eq(user)
      end
    end

    context '#for_account' do
      let!(:account) { user.accounts.first }
      let!(:web_property_from_account) { Hisui::Management::WebProperty.for_account(account) }

      it 'creates a new web property instance' do
        expect(web_property.id).to eq('UA-54516992-3')
        expect(web_property.name).to eq('Demo Account (Beta)')
        expect(web_property.account_id).to eq('54516992')
        expect(web_property.website_url).to eq('https://shop.googlemerchandisestore.com')
        expect(web_property.user).to eq(user)
      end
    end
  end
end
