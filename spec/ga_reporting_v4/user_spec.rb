describe GaReportingV4::User do
  let!(:user) { GaReportingV4::User.new(access_token) }

  context 'Class methods' do
    context '#new' do
      it 'creates a new user instance' do
        expect(user).to respond_to(:access_token)
      end
    end
  end

  context 'Instance methods' do
    context '#accounts' do
      let!(:account) { user.accounts.first }

      it 'returns all analytics accounts' do
        expect(account.id).to eq('54516992')
        expect(account.name).to eq('Demo Account (Beta)')
        expect(account.user).to eq(user)
      end
    end

    context '#account_summaries' do
      let!(:account_summaries) { user.account_summaries }

      it 'returns all analytics account_summaries' do
        expect(account_summaries.length).to eq(2)
      end
    end

    context '#profiles' do
      let!(:profiles) { user.profiles }

      it 'returns all analytics profiles' do
        expect(profiles.length).to eq(4)
      end
    end

    context '#segments' do
      let!(:segments) { user.segments }

      it 'returns all analytics segments' do
        expect(segments.length).to eq(25)
      end
    end

    context '#web_properties' do
      let!(:web_properties) { user.web_properties }

      it 'returns all analytics web_properties' do
        expect(web_properties.length).to eq(2)
      end
    end
  end
end
