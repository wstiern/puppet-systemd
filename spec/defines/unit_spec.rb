require 'spec_helper'

describe 'systemd::unit' do
	let(:title) { 'systemd-deftype-test' }
	context 'default' do
		it { is_expected.to compile }
	end
end
