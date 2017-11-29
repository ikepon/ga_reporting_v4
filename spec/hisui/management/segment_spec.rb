describe Hisui::Management::Segment do
  let!(:user) { Hisui::User.new(access_token) }
  let!(:attributes) { {
    'id' => '-2',
    'name' => 'New Users',
    'definition' => 'sessions::condition::ga:userType==New Visitor'
  }.with_indifferent_access }
  let!(:segment) { Hisui::Management::Segment.new(attributes, user) }

  context 'Class methods' do
    context '#new' do
      it 'creates a new segment instance' do
        expect(segment.id).to eq('-2')
        expect(segment.name).to eq('New Users')
        expect(segment.definition).to eq('sessions::condition::ga:userType==New Visitor')
        expect(segment.user).to eq(user)
      end
    end
  end
end
