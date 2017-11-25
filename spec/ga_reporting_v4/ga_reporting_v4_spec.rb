require 'spec_helper'

describe GaReportingV4 do
  context 'from_ga_string' do
    it 'converts a string google analytics syntax' do
      expect(GaReportingV4.from_ga_string('ga:whatever')).to eq('whatever')
      expect(GaReportingV4.from_ga_string('mcf:whatever')).to eq('whatever')
      expect(GaReportingV4.from_ga_string('rt:whatever')).to eq('whatever')
    end
  end

  context 'to_ga_string' do
    it 'converts a string to google analytics syntax' do
      expect(GaReportingV4.to_ga_string('whatever')).to eq('ga:whatever')
      expect(GaReportingV4.to_ga_string('whatever', 'mcf')).to eq('mcf:whatever')
    end
  end
end
