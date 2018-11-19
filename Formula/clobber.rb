class Clobber < Formula
  desc "Command-line application for building Clover"
  homepage "https://github.com/Dids/clobber"
  url "https://github.com/Dids/clobber/archive/v0.1.5.tar.gz"
  sha256 "1a872aa961b77ad47e560e0bb7b0e9facc80dc5ff8ffd1dfc27307b9853567f5"
  revision 2

  # Setup head/master branch support (install with --HEAD)
  head "https://github.com/Dids/Clobber.git"

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
    ln_s buildpath, buildpath/"go/src/github.com/Dids/clobber"

    # Install build dependencies
    system "cd go/src/github.com/Dids/clobber && dep ensure"

    # Print out target version
    ohai "Building version #{version}.."

    ## NOTE: Homebrew/Formula/Ruby doesn't seem to like escaping quotes,
    ##       so we had to resort to using a build script/wrapper instead

    # Build the application
    system "./.scripts/build.sh", version, buildpath/"clobber"

    # Print the version
    system buildpath/"clobber",  "--version"

    # Install the application
    bin.install buildpath/"clobber"

    # Test that the version matches
    if "clobber version #{version}" != `#{bin}/clobber --version`.strip
      odie "Output of 'clobber --version' did not match the current version (#{version})."
    end
  end

  test do
    # Test that the version matches
    assert_equal "clobber version #{version}", `#{bin}/clobber --version`.strip
  end
end
