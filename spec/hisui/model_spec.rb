describe Hisui::Model do
  context "A Class extended with Hisui::Model" do
    let!(:model_class) { Class.new.tap { |klass| klass.extend(Hisui::Model) } }
    context '.metrics' do
      it 'has a metric' do
        model_class.metrics :pageviews

        expect(model_class.metrics).to eq(Set.new([expression: 'ga:pageviews']))
      end

      it 'has metrics' do
        model_class.metrics :pageviews, :sessions

        expect(model_class.metrics).to eq(Set.new([{ expression: 'ga:pageviews'}, { expression: 'ga:sessions'}]))
      end

      it 'does not add duplicated metrics' do
        model_class.metrics :pageviews, :sessions
        model_class.metrics :sessions
        model_class.metrics :sessions, :sessions

        expect(model_class.metrics).to eq(Set.new([{ expression: 'ga:pageviews'}, { expression: 'ga:sessions'}]))
      end
    end

    context '.dimensions' do
      it 'has a dimension' do
        model_class.dimensions :medium

        expect(model_class.dimensions).to eq(Set.new([name: 'ga:medium']))
      end

      it 'has dimensions' do
        model_class.dimensions :medium, :source

        expect(model_class.dimensions).to eq(Set.new([{ name: 'ga:medium'}, { name: 'ga:source'}]))
      end

      it 'does not add duplicated dimensions' do
        model_class.dimensions :medium, :source
        model_class.dimensions :source
        model_class.dimensions :source, :source

        expect(model_class.dimensions).to eq(Set.new([{ name: 'ga:medium'}, { name: 'ga:source'}]))
      end
    end

    context '.order_bys' do
      it 'has a order by' do
        model_class.order_bys({ field_name: 'ga:sessions', order_type: 'VALUE', sort_order: 'DESCENDING' })

        expect(model_class.order_bys).to eq(Set.new([{ field_name: 'ga:sessions', order_type: 'VALUE', sort_order: 'DESCENDING' }]))
      end

      it 'has order bys' do
        model_class.order_bys({ field_name: 'ga:sessions', order_type: 'VALUE', sort_order: 'DESCENDING' })
        model_class.order_bys({ field_name: 'ga:users', order_type: 'VALUE', sort_order: 'ASCENDING' })

        expect(model_class.order_bys).to eq(Set.new([{ field_name: 'ga:sessions', order_type: 'VALUE', sort_order: 'DESCENDING' }, { field_name: 'ga:users', order_type: 'VALUE', sort_order: 'ASCENDING' }]))
      end

      it 'does not add duplicated order bys' do
        model_class.order_bys({ field_name: 'ga:sessions', order_type: 'VALUE', sort_order: 'DESCENDING' })
        model_class.order_bys({ field_name: 'ga:sessions', order_type: 'VALUE', sort_order: 'DESCENDING' })

        expect(model_class.order_bys).to eq(Set.new([{ field_name: 'ga:sessions', order_type: 'VALUE', sort_order: 'DESCENDING' }]))
      end
    end

    context '.results' do
      let!(:user) { Hisui::User.new(access_token) }
      let!(:profile) { user.profiles[3] }

      context 'when date range is one' do
        it 'has results' do
          model_class.metrics :pageviews, :sessions
          model_class.dimensions :medium
          model_class.order_bys({ field_name: 'ga:sessions', order_type: 'VALUE', sort_order: 'DESCENDING' })
          results = model_class.results(profile: profile, start_date: Date.new(2017, 10, 1), end_date: Date.new(2017, 10, 31))

          expect(results.data?).to be(true)
          expect(results.primary.first).to respond_to(:medium)
          expect(results.primary.first).to respond_to(:pageviews)
          expect(results.primary.first).to respond_to(:sessions)
          expect(results.primary_total).to respond_to(:pageviews)
          expect(results.primary_total).to respond_to(:sessions)
          expect(results.compare.first).to respond_to(:medium)
          expect(results.compare.first).to respond_to(:pageviews)
          expect(results.compare.first).to respond_to(:sessions)
          expect(results.compare_total).to respond_to(:pageviews)
          expect(results.compare_total).to respond_to(:sessions)
        end
      end

      context 'when date ranges are two' do
        it 'has results' do
          model_class.metrics :pageviews, :sessions
          model_class.dimensions :medium
          model_class.order_bys({ field_name: 'ga:sessions', order_type: 'VALUE', sort_order: 'DESCENDING' })
          results = model_class.results(
            profile: profile,
            start_date: Date.new(2017, 10, 1),
            end_date: Date.new(2017, 10, 31),
            compare_start_date: Date.new(2017, 9, 1),
            compare_end_date: Date.new(2017, 9, 30)
          )

          expect(results.data?).to be(true)
          expect(results.primary.first).to respond_to(:medium)
          expect(results.primary.first).to respond_to(:pageviews)
          expect(results.primary.first).to respond_to(:sessions)
          expect(results.primary_total).to respond_to(:pageviews)
          expect(results.primary_total).to respond_to(:sessions)
          expect(results.compare.first).to respond_to(:medium)
          expect(results.compare.first).to respond_to(:pageviews)
          expect(results.compare.first).to respond_to(:sessions)
          expect(results.compare_total).to respond_to(:pageviews)
          expect(results.compare_total).to respond_to(:sessions)
        end
      end
    end
  end
end
