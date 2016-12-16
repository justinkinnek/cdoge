module OmniauthHelpers
  OmniAuth.config.test_mode = true

  PROVIDER_PROFILE_UIDS = ['123', 'Abc123', '1234567890'].freeze

  def load_omniauth_mock(data = {})
    @omniauth_file ||= File.open(File.expand_path('../../fixtures/omniauth.yml', __FILE__)).read
    yml = @omniauth_file.gsub(/{(.*)}/) {data[$1] || ''}
    @omniauth_mocks = YAML.load(yml)
  end

  def user_data(options = {})
    unless options[:user].is_a?(User)
      attrs = options[:attrs] && options[:attrs].symbolize_keys || {}
      options[:user] = FactoryGirl.attributes_for(:user).symbolize_keys.merge(attrs)
    end
    Hashie::Mash.new({
      uid: PROVIDER_PROFILE_UIDS.sample,
      username: options[:user][:username],
      email: options[:user][:email],
      first_name: 'Justin',
      last_name: 'Lynch',
      name: 'Justin Lynch',
      location: 'New York, NY USA',
      image_url: 'http://www.facebook.com/624914/picture?type=square',
      bio: 'Check out my profile on myspace!',
      website: 'http://twitter.com/justinlynch',
      nickname: 'discoanimal',
      verified: true
    })
  end
end
