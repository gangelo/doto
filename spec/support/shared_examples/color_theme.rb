# frozen_string_literal: true

shared_examples 'the color theme is the current color theme in the configuration' do
  it 'the color theme is the current configuration color theme' do
    expect(Doto::Models::ColorTheme.current_or_default.theme_name).to eq(theme_name)
  end
end

shared_examples 'the color theme is not the current color theme in the configuration' do
  it 'the color theme is the current configuration color theme' do
    expect(Doto::Models::ColorTheme.current_or_default.theme_name).to_not eq(theme_name)
  end
end
