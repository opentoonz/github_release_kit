require 'thor'

module GithubReleaseKit
  class CLI < Thor
    desc "github_release_kit", "release kit"
    def release
      p "hello"
    end
  end
end
