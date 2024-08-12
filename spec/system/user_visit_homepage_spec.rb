require 'spec_helper'
require_relative '../../app/app'

RSpec.describe 'User visit homepage' do
  it 'and sees a list of all tests' do
    visit '/hello'

    expect(page).to have_content 'Hello world!'
  end
end
