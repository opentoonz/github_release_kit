require 'thor'
require 'octokit'
require 'retriable'

module GithubReleaseKit
  class CLI < Thor
    class_option :token, :type => :string, :required => true
    class_option :user, :type => :string, :required => true
    class_option :api_url, :type => :string, :default => "https://api.github.com"
    class_option :timeout, :type => :numeric, :default => 60*10


    desc "release REPOSITORY_URL FILEPATH", "release kit"
    option :tag, :default => "nightly"
    option :retry, :type => :numeric, :default => 10
    option :name
    def release(repository_url, filepath)
      filename = File.basename(filepath)
      init
      tag = options[:tag]

      repository = Octokit::Repository.from_url(repository_url)
      releases = Octokit.releases(repository)
      nightly_release = releases.select{|repo| repo.tag_name == tag}.first
      nightly_release_assets = Octokit.release_assets(nightly_release.url)
      existing_asset = nightly_release_assets.select{|asset| asset.name == filename}.first
      unless existing_asset.nil?
        p "delete existing_asset(#{existing_asset.url})"
        Octokit.delete_release_asset(existing_asset.url)
      end
      p "upload to #{nightly_release.url}"

      # Retriable is workaround for network trouble
      Retriable.retriable tries: options[:retry] do
        p "retry"
        Octokit.upload_asset(nightly_release.url, filepath)
      end

      # Rename the release
      unless options[:name].nil?
        Octokit.update_release(nightly_release.url, :name => options[:name])
      end
    end

    desc "create REPOSITORY_URL", "release kit"
    option :tag, :default => "nightly"
    option :name
    def create(repository_url)
      init
      tag = options[:tag]
      name = if options[:name].nil?
               Time.now.utc.to_s
             else
               options[:name]
             end

      repository = Octokit::Repository.from_url(repository_url)
      releases = Octokit.releases(repository)
      duplicate_release = releases.select{|repo| repo.tag_name == tag}.first
      if duplicate_release.nil?
        optional_args = {prerelease: true}
        optional_args[:name] = name unless name.nil?
        Octokit.create_release(repository, tag, **optional_args)
        p "successfully released"
      else
        p "already released"
        p duplicate_release
      end
    end


    private
    def init
      Octokit.configure do |c|
        c.api_endpoint = options[:api_url]
        c.login = options[:user]
        c.password = options[:token]
        c.connection_options = {request: {timeout: options[:timeout]}}
      end
    end
  end
end
