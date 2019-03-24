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

    context '.filters_expression' do
      it 'has a filters expression' do
        model_class.filters_expression({ field_name: 'device_category', operator: '==', value: 'desktop' })

        expect(model_class.filters_expression).to eq('ga:deviceCategory==desktop')
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

          expect(results.primary.first.medium).to eq('organic')
          expect(results.primary.first.pageviews).to eq('673')
          expect(results.primary.first.sessions).to eq('509')
          expect(results.primary.second.medium).to eq('(none)')
          expect(results.primary.second.pageviews).to eq('58')
          expect(results.primary.second.sessions).to eq('23')
          expect(results.primary.third.medium).to eq('referral')
          expect(results.primary.third.pageviews).to eq('2')
          expect(results.primary.third.sessions).to eq('2')
          expect(results.primary_total.pageviews).to eq('733')
          expect(results.primary_total.sessions).to eq('534')

          expect(results.comparing.first.medium).to eq('organic')
          expect(results.comparing.first.pageviews).to be_nil
          expect(results.comparing.first.sessions).to be_nil
          expect(results.comparing.second.medium).to eq('(none)')
          expect(results.comparing.second.pageviews).to be_nil
          expect(results.comparing.second.sessions).to be_nil
          expect(results.comparing.third.medium).to eq('referral')
          expect(results.comparing.third.pageviews).to be_nil
          expect(results.comparing.third.sessions).to be_nil
          expect(results.comparing_total.pageviews).to be_nil
          expect(results.comparing_total.sessions).to be_nil

          expect(results.rows.first.dimensions.medium).to eq('organic')
          expect(results.rows.first.primary.pageviews).to eq('673')
          expect(results.rows.first.primary.sessions).to eq('509')
          expect(results.rows.first.comparing.pageviews).to be_nil
          expect(results.rows.first.comparing.sessions).to be_nil

          expect(results.rows.second.dimensions.medium).to eq('(none)')
          expect(results.rows.second.primary.pageviews).to eq('58')
          expect(results.rows.second.primary.sessions).to eq('23')
          expect(results.rows.second.comparing.pageviews).to be_nil
          expect(results.rows.second.comparing.sessions).to be_nil

          expect(results.rows.third.dimensions.medium).to eq('referral')
          expect(results.rows.third.primary.pageviews).to eq('2')
          expect(results.rows.third.primary.sessions).to eq('2')
          expect(results.rows.third.comparing.pageviews).to be_nil
          expect(results.rows.third.comparing.sessions).to be_nil
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
            comparing_start_date: Date.new(2017, 9, 1),
            comparing_end_date: Date.new(2017, 9, 30)
          )

          expect(results.data?).to be(true)

          expect(results.primary.first.medium).to eq('organic')
          expect(results.primary.first.pageviews).to eq('673')
          expect(results.primary.first.sessions).to eq('509')
          expect(results.primary.second.medium).to eq('(none)')
          expect(results.primary.second.pageviews).to eq('58')
          expect(results.primary.second.sessions).to eq('23')
          expect(results.primary.third.medium).to eq('referral')
          expect(results.primary.third.pageviews).to eq('2')
          expect(results.primary.third.sessions).to eq('2')
          expect(results.primary_total.pageviews).to eq('733')
          expect(results.primary_total.sessions).to eq('534')

          expect(results.comparing.first.medium).to eq('organic')
          expect(results.comparing.first.pageviews).to eq('595')
          expect(results.comparing.first.sessions).to eq('480')
          expect(results.comparing.second.medium).to eq('(none)')
          expect(results.comparing.second.pageviews).to eq('78')
          expect(results.comparing.second.sessions).to eq('32')
          expect(results.comparing.third.medium).to eq('referral')
          expect(results.comparing.third.pageviews).to eq('7')
          expect(results.comparing.third.sessions).to eq('7')
          expect(results.comparing_total.pageviews).to eq('680')
          expect(results.comparing_total.sessions).to eq('519')

          expect(results.rows.first.dimensions.medium).to eq('organic')
          expect(results.rows.first.primary.pageviews).to eq('673')
          expect(results.rows.first.primary.sessions).to eq('509')
          expect(results.rows.first.comparing.pageviews).to eq('595')
          expect(results.rows.first.comparing.sessions).to eq('480')

          expect(results.rows.second.dimensions.medium).to eq('(none)')
          expect(results.rows.second.primary.pageviews).to eq('58')
          expect(results.rows.second.primary.sessions).to eq('23')
          expect(results.rows.second.comparing.pageviews).to eq('78')
          expect(results.rows.second.comparing.sessions).to eq('32')

          expect(results.rows.third.dimensions.medium).to eq('referral')
          expect(results.rows.third.primary.pageviews).to eq('2')
          expect(results.rows.third.primary.sessions).to eq('2')
          expect(results.rows.third.comparing.pageviews).to eq('7')
          expect(results.rows.third.comparing.sessions).to eq('7')
        end
      end

      context 'when date ranges are two, and dimensions are user_type and date' do
        it 'has results' do
          model_class.metrics :pageviews, :sessions
          model_class.dimensions :user_type, :date
          results = model_class.results(
            profile: profile,
            start_date: Date.new(2017, 10, 1),
            end_date: Date.new(2017, 10, 31),
            comparing_start_date: Date.new(2017, 9, 1),
            comparing_end_date: Date.new(2017, 9, 30)
          )

          expect(results.data?).to be(true)

          expect(results.primary.first.date).to eq('20171001')
          expect(results.primary.last.date).to eq('20171031')
          expect(results.comparing.first.date).to eq('20170901')
          expect(results.comparing.last.date).to eq('20170930')
        end
      end

      context 'when date ranges are two, and dimensions is dateHour' do
        it 'has results' do
          model_class.metrics :pageviews, :sessions
          model_class.dimensions :date_hour
          results = model_class.results(
            profile: profile,
            start_date: Date.new(2017, 10, 1),
            end_date: Date.new(2017, 10, 31),
            comparing_start_date: Date.new(2017, 9, 1),
            comparing_end_date: Date.new(2017, 9, 30)
          )

          expect(results.data?).to be(true)

          expect(results.primary.first.dateHour).to eq('2017100100')
          expect(results.primary.last.dateHour).to eq('2017103121')
          expect(results.comparing.first.dateHour).to eq('2017090108')
          expect(results.comparing.last.dateHour).to eq('2017093022')
        end
      end

      context 'when date ranges are two, and dimensions is yearMonth' do
        it 'has results' do
          model_class.metrics :pageviews, :sessions
          model_class.dimensions :year_month
          results = model_class.results(
            profile: profile,
            start_date: Date.new(2018, 1, 1),
            end_date: Date.new(2018, 12, 31),
            comparing_start_date: Date.new(2017, 1, 1),
            comparing_end_date: Date.new(2017, 12, 31)
          )

          expect(results.data?).to be(true)

          expect(results.primary.first.yearMonth).to eq('201801')
          expect(results.primary.last.yearMonth).to eq('201812')
          expect(results.comparing.first.yearMonth).to eq('201708')
          expect(results.comparing.last.yearMonth).to eq('201712')
        end
      end

      context 'when date ranges are two, and dimensions are date and dateHourMinute' do
        it 'has results' do
          model_class.metrics :pageviews, :sessions
          model_class.dimensions :date_hour_minute, :date
          results = model_class.results(
            profile: profile,
            start_date: Date.new(2017, 10, 1),
            end_date: Date.new(2017, 10, 31),
            comparing_start_date: Date.new(2017, 9, 1),
            comparing_end_date: Date.new(2017, 9, 30)
          )

          expect(results.data?).to be(true)

          # NOTE: 1,000 data per request. In this case, primary data is 375 and comparing data is 625
          #       So,  `results.primary.last.dateHourMinute` is '201710191320'.
          expect(results.primary.first.dateHourMinute).to eq('201710010001')
          expect(results.primary.last.dateHourMinute).to eq('201710191320')
          expect(results.comparing.first.dateHourMinute).to eq('201709010841')
          expect(results.comparing.last.dateHourMinute).to eq('201709302204')
        end
      end

      context 'when filters_expression is set' do
        it 'has results' do
          model_class.metrics :pageviews, :sessions
          model_class.dimensions :medium
          model_class.filters_expression({ field_name: 'medium', operator: '==', value: 'organic' })
          results = model_class.results(profile: profile, start_date: Date.new(2017, 10, 1), end_date: Date.new(2017, 10, 31))

          expect(results.data?).to be(true)
          expect(results.primary.count).to eq(1)
          expect(results.primary.first.medium).to eq('organic')
        end
      end
    end
  end
end
