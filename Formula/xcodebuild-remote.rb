class XcodebuildRemote < Formula
  desc "Extends xcodebuild to support remote repositories"
  homepage "https://github.com/Dids/xcodebuild-remote"
  url "https://github.com/Dids/xcodebuild-remote/archive/master.tar.gz"
  version "0.0.1"
  sha256 "821afc7406b02dd7874f31f1b947282cedb457c3bbfa982ebf0e488c81b25598"
  revision 0

  # Setup head/master branch support (install with --HEAD)
  head "https://github.com/Dids/xcodebuild-remote.git"

  # No bottling necessary
  bottle :unneeded

  # We need dep for build dependencies
  depends_on "dep" => :build

  # We need go for building
  depends_on "go" => :build

  # We needs subversion for SVN support
  depends_on "subversion"
  
  # We need Xcode/xcodebuild for running the application
  depends_on :xcode

  # Define the installation steps
  def install
    # Define GOPATH
    ENV["GOPATH"] = buildpath/"go"

    # Create the required directories
    (buildpath/"go/bin").mkpath
    (buildpath/"go/pkg").mkpath
    (buildpath/"go/src").mkpath
    (buildpath/"go/src/github.com/Dids").mkpath

    # Symlink the package directory
    ln_s buildpath, buildpath/"go/src/github.com/Dids/xcodebuild-remote"

    # Install build dependencies
    system "cd go/src/github.com/Dids/xcodebuild-remote && dep ensure"

    # Print out target version
    ohai "Building version #{version}.."

    ## NOTE: Homebrew/Formula/Ruby doesn't seem to like escaping quotes,
    ##       so we had to resort to using a build script/wrapper instead

    # Build the application
    system "./.scripts/build.sh", version, buildpath/"xcodebuild-remote"

    # Print the version
    system buildpath/"xcodebuild-remote",  "--version"

    # Install the application
    bin.install buildpath/"xcodebuild-remote"

    # Test that the version matches
    if "xcodebuild-remote version #{version}" != `#{bin}/xcodebuild-remote --version`.strip
      odie "Output of 'xcodebuild-remote --version' did not match the current version (#{version})."
    end
  end

  test do
    # Test that the version matches
    assert_equal "xcodebuild-remote version #{version}", `#{bin}/xcodebuild-remote --version`.strip
  end
end
